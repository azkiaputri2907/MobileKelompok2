import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/auth/onboarding_page.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart';
import 'package:mobile_kelompok2/screens/admin/admindashboard.dart'; // Import for AdminDashboard
import 'package:mobile_kelompok2/screens/lupa_password_screen.dart';
import 'package:mobile_kelompok2/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // Panggil metode login yang diperbarui yang mengembalikan peran, nama, dan ID pengguna
    // Asumsi AuthService.login sekarang mengembalikan Map seperti
    // {'role': 'Dosen', 'userName': 'Nama Dosen', 'ref_Id': 123}
    final Map<String, dynamic>? loginResult = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (loginResult != null && mounted) {
      final String? userRole = loginResult['role'];
      final String? userName = loginResult['userName']; // Dapatkan nama pengguna
      final int? refId = loginResult['ref_Id']; // Dapatkan ID referensi (dosenId/adminId)

      if (userRole != null && userName != null) {
        // Login berhasil, navigasi berdasarkan peran pengguna
        if (userRole == 'Dosen') {
          if (refId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardDosen(userName: userName, dosenId: refId),
              ),
            );
          } else {
            _showLoginFailedDialog('ID Dosen tidak ditemukan. Silakan hubungi administrator.');
          }
        } else if (userRole == 'Admin Pegawai') {
          // Untuk Admin Pegawai, mungkin tidak perlu refId, atau bisa diteruskan jika ada
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          _showLoginFailedDialog('Peran pengguna tidak dikenal. Silakan hubungi administrator.');
        }
      } else {
        _showLoginFailedDialog('Gagal mendapatkan informasi peran atau nama pengguna.');
      }
    } else {
      // Login gagal (loginResult adalah null)
      _showLoginFailedDialog('Email atau Password salah.');
    }
  }

  // Metode pembantu untuk menampilkan dialog login gagal
  void _showLoginFailedDialog(String message) {
    if (!mounted) return; // Pastikan widget masih mounted sebelum menampilkan dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingPage()),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Yuk, login dulu sebelum lanjut',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Email',
                  filled: true,
                  fillColor: const Color(0xFFF1F3F6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Masukkan Password',
                  filled: true,
                  fillColor: const Color(0xFFF1F3F6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Harus berupa kombinasi minimal 8 huruf, angka, dan simbol.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LupaPasswordScreen()),
                    );
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Lupa Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Masuk',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}