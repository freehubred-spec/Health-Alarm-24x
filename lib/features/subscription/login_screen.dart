import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login to Start 15-Day Free Trial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            if (!_isOtpSent) ...[
              TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number', prefixText: '+91 ', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  await _authService.sendOTP(
                    phoneNumber: '+91${_phoneController.text.trim()}',
                    onCodeSent: () => setState(() => _isOtpSent = true),
                    onError: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e))),
                  );
                },
                child: const Text('Send OTP'),
              ),
            ] else ...[
              TextField(controller: _otpController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter OTP', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  var res = await _authService.verifyOTP(
                    smsCode: _otpController.text.trim(),
                    onError: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e))),
                  );
                  if (res != null) widget.onLoginSuccess();
                },
                child: const Text('Verify OTP'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
