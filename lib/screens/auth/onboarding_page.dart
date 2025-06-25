import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Definisi kelas OnboardingData
// Biasanya ini ada di file terpisah seperti onboarding_data.dart
class OnboardingData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingData({required this.imagePath, required this.title, required this.description});
}

final List<OnboardingData> onboardingDataList = [
  OnboardingData(
    imagePath: 'assets/images/onboarding1.jpg', // Ganti dengan aset gambar Anda
    title: 'Selamat Datang!',
    description: 'Temukan berbagai fitur menarik yang akan membantu Anda.',
  ),
  OnboardingData(
    imagePath: 'assets/images/onboarding2.jpg', // Ganti dengan aset gambar Anda
    title: 'Mudah Digunakan',
    description: 'Antarmuka yang intuitif membuat pengalaman Anda lebih menyenangkan.',
  ),
  OnboardingData(
    imagePath: 'assets/images/onboarding3.jpg', // Ganti dengan aset gambar Anda
    title: 'Siap Memulai?',
    description: 'Mari kita mulai perjalanan Anda bersama kami sekarang!',
  ),
];


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void _nextPage() {
    if (currentIndex == onboardingDataList.length - 1) {
      // Navigasi ke halaman login saat onboarding selesai
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Warna latar belakang sesuai login page
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingDataList.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (context, index) {
                final data = onboardingDataList[index];
                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        data.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // Pastikan gambar di-handle dengan baik untuk berbagai ukuran layar
                        // Misalnya, dengan menggunakan BoxFit.contain atau BoxFit.cover sesuai kebutuhan
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 26, // Ukuran font disesuaikan dengan judul login
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37474F), // Warna teks judul sesuai login
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.description,
                            style: const TextStyle(
                              fontSize: 16, // Ukuran font disesuaikan
                              height: 1.5,
                              color: Colors.black54, // Warna deskripsi
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: _controller,
            count: onboardingDataList.length,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Color(0xFF9FBADE), // Warna biru soft dari login page
              dotColor: Colors.grey, // Warna dot tidak aktif
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Tinggi tombol disesuaikan dengan login page
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4682B4), // Warna tombol sesuai login page
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Radius sudut sesuai login page
                  elevation: 3,
                ),
                child: Text(
                  currentIndex == onboardingDataList.length - 1 ? 'Mulai' : 'Lanjut',
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold), // Gaya teks sesuai login page
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
