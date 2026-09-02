import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/auth_service.dart';
import 'features/dashboard/main_dashboard.dart';
import 'features/subscription/login_screen.dart';
import 'features/subscription/paywall_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('alarms_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Talking Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const SplashAuthCheck(),
    );
  }
}

class SplashAuthCheck extends StatelessWidget {
  const SplashAuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService().checkAccessStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          String reason = snapshot.data!['reason'];

          if (reason == 'NOT_LOGGED_IN') {
            return LoginScreen(
              onLoginSuccess: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainDashboard()),
                );
              },
            );
          } else if (reason == 'TRIAL_EXPIRED') {
            return const PaywallScreen();
          } else {
            return const MainDashboard();
          }
        }

        return LoginScreen(
          onLoginSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainDashboard()),
            );
          },
        );
      },
    );
  }
}
