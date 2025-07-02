import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';
import 'package:mobile_kelompok2/screens/auth/onboarding_page.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart'; // Tetap import untuk referensi tipe
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
      // Pastikan Anda sudah mengonfigurasi `flutter_localizations` di `pubspec.yaml`
      // dan menginisialisasinya di sini jika Anda ingin locale 'id_ID' bekerja untuk DateFormat.
      // Contoh:
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', ''), // English, no country code
      //   Locale('id', 'ID'), // Indonesian, Indonesia
      // ],
      home: const OnboardingPage(), // Atau ubah ke LoginPage jika Anda ingin melewati onboarding
      routes: {
        '/login': (context) => const LoginScreen(),
        // Rute '/dashboard_dosen' telah dihapus karena navigasi ke DashboardDosen
        // kini menangani passing data (userName) secara langsung melalui MaterialPageRoute dari LoginPage.
        '/dashboard_admin': (context) => const AdminDashboard(userName: '',), // Rute untuk Admin Dashboard
      },
    );
  }
}