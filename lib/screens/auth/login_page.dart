import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/auth/onboarding_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // TODO: Hubungkan dengan backend Laravel atau lakukan proses otentikasi
      print('Email: $email\nPassword: $password');
      // Navigasi ke halaman dashboard setelah login berhasil
      // Pastikan '/dashboard' terdaftar di routes main.dart Anda
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Background warna cerah sesuai gambar
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas dengan warna biru soft dan ilustrasi
              Container(
                width: double.infinity,
                height: 200, // Mengurangi tinggi container header
                decoration: const BoxDecoration(
                  color: Color(0xFF9FBADE), // Warna biru soft
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tombol kembali di pojok kiri atas
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Handle back/close action
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingPage()),
                        (route) => false, // Menghapus semua route sebelumnya
                                      );                        },
                      ),
                    ),
                    // Ilustrasi orang dengan bulan
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://placehold.co/120x120/ffffff/000000?text=Your+Illustration', // Mengurangi ukuran placeholder
                          height: 120, // Mengurangi tinggi ilustrasi
                          width: 120, // Mengurangi lebar ilustrasi
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/dosen_ilustrasi.png', // Fallback to local asset
                              height: 150, // Sesuaikan fallback juga
                              width: 150, // Sesuaikan fallback juga
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37474F),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'kia@gmail.com', // Contoh hint text
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6A5AE0)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 73, 141, 249), width: 2),
                              ),
                              isDense: true, // Membuat TextField lebih padat
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Mengurangi padding internal
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Email wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6A5AE0)),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF4682B4), width: 2),
                              ),
                              isDense: true, // Membuat TextField lebih padat
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Mengurangi padding internal
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Password wajib diisi' : null,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Tambahkan navigasi ke halaman lupa password
                                print('Lupa Password?');
                              },
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(color: Color(0xFF6A5AE0), fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4682B4), // Warna kuning sesuai gambar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
