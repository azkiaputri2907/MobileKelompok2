import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';
import 'package:mobile_kelompok2/screens/auth/onboarding_page.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboard.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(), // Atau ganti ke LoginPage jika mau skip onboarding
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardDosen(),
        
      },
    );
  }
}
