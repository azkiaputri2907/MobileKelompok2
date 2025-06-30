// import 'package:flutter/material.dart';
// import '../models/onboarding_model.dart';
// import '../widgets/onboarding_content.dart';
// import '../auth/login_screen.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   int currentIndex = 0;
//   final PageController _controller = PageController();

//   final List<OnboardingModel> data = [
//     OnboardingModel(
//       image: 'assets/images/onboarding1.jpeg',
//       title: '🎓 Belajar Jadi Lebih Simpel & Seru',
//       description: 'Kini kamu bisa belajar hal baru tanpa ribet! Cukup dari ponselmu, semua materi tersedia dan bisa diakses kapan pun kamu punya waktu.',
//     ),
//     OnboardingModel(
//       image: 'assets/images/onboarding2.jpeg',
//       title: '🤝 Belajarnya Bareng-Bareng !',
//       description: 'Ada komunitas dan mentor yang siap bantu kamu setiap langkah. Jadi belajar nggak cuma sendiri, tapi rame dan seru bareng yang lain.',
//     ),
//     OnboardingModel(
//       image: 'assets/images/onboarding3.jpeg',
//       title: '📚 Belajar Tanpa Batas, Kapan Aja',
//       description: 'Nggak perlu nunggu waktu luang lama cukup beberapa menit sehari, kamu udah bisa dapet ilmu baru yang bermanfaat langsung dari HP kamu.',
//     ),
//   ];

//   void nextPage() {
//     if (currentIndex == data.length - 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     } else {
//       _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _controller,
//               itemCount: data.length,
//               onPageChanged: (index) => setState(() => currentIndex = index),
//               itemBuilder: (_, index) => OnboardingContent(
//                 image: data[index].image,
//                 title: data[index].title,
//                 description: data[index].description,
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               data.length,
//               (index) => AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 width: currentIndex == index ? 16 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: currentIndex == index ? Colors.blue : Colors.grey,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: nextPage,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 child: const Text('Get Started', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }
