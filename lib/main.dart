import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';
import 'package:mobile_kelompok2/screens/auth/onboarding_page.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart';
import 'package:mobile_kelompok2/screens/admin/admindashboard.dart'; // Import AdminDashboard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Ensure you have flutter_localizations configured in your pubspec.yaml
      // and initialized here if you want 'id_ID' locale to work for DateFormat.
      // E.g.:
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', ''), // English, no country code
      //   Locale('id', 'ID'), // Indonesian, Indonesia
      // ],
      home: const OnboardingPage(), // Or change to LoginPage if you want to skip onboarding
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard_dosen': (context) => const DashboardDosen(), // Specific route for Dosen
        '/dashboard_admin': (context) => const AdminDashboard(),   // **NEW: Route for Admin Dashboard**
      },
    );
  }
}
