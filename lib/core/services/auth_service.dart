import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  Future<void> sendOTP({
    required String phoneNumber,
    required Function() onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification Failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<UserCredential?> verifyOTP({
    required String smsCode,
    required Function(String error) onError,
  }) async {
    try {
      if (_verificationId == null) {
        onError('Verification ID missing.');
        return null;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'phone': user.phoneNumber,
            'registration_date': FieldValue.serverTimestamp(),
            'is_subscribed': false,
            'subscription_expiry': null,
          });
        }
      }

      return userCredential;
    } catch (e) {
      onError(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> checkAccessStatus() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return {'hasAccess': false, 'reason': 'NOT_LOGGED_IN'};
    }

    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      return {'hasAccess': false, 'reason': 'NO_USER_DATA'};
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSubscribed = data['is_subscribed'] ?? false;

    if (isSubscribed) {
      Timestamp? expiry = data['subscription_expiry'];
      if (expiry != null && expiry.toDate().isAfter(DateTime.now())) {
        return {'hasAccess': true, 'reason': 'PAID_SUBSCRIBER'};
      }
    }

    Timestamp? regTimestamp = data['registration_date'];
    if (regTimestamp != null) {
      DateTime regDate = regTimestamp.toDate();
      int daysPassed = DateTime.now().difference(regDate).inDays;

      if (daysPassed <= 15) {
        int remainingDays = 15 - daysPassed;
        return {
          'hasAccess': true,
          'reason': 'FREE_TRIAL',
          'remainingDays': remainingDays
        };
      }
    }

    return {'hasAccess': false, 'reason': 'TRIAL_EXPIRED'};
  }
}
