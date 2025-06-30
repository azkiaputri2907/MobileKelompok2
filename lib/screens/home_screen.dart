// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:simpadu/services/auth_service.dart';
// import 'akademik/tahun_akademik_screen.dart';
// import 'mahasiswa/mahasiswa_screen.dart';
// import 'kelas/kelas_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   late Timer _timer;
//   late DateTime _currentTime;

//   // Data user login
//   String? _userName;
//   String? _userEmail;

//   final AuthService _authService = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     _currentTime = DateTime.now().toLocal();

//     // Start clock
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _currentTime = DateTime.now().toLocal();
//       });
//     });

//     // Ambil data user saat init
//     _fetchUserData();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   // Fungsi untuk ambil user dari API
//   Future<void> _fetchUserData() async {
//     final data = await _authService.getUserData();
//     if (data != null) {
//       setState(() {
//         _userName = data['user']['name'] ?? 'Pengguna';
//         _userEmail = data['user']['email'] ?? '-';
//       });
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         backgroundColor: Colors.blue[800],
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset('assets/images/logo.png'),
//         ),
//         title: const Text(
//           'SIMPADU',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         actions: const [
//           Icon(Icons.notifications, color: Colors.white),
//           SizedBox(width: 10),
//           Icon(Icons.settings, color: Colors.white),
//           SizedBox(width: 10),
//         ],
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           _buildHomeContent(),
//           _buildMenuPage(context),
//           _buildAccountPage(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
//         ],
//       ),
//     );
//   }

//   Widget _buildHomeContent() {
//     final formattedTime = DateFormat.Hms().format(_currentTime);
//     final formattedDate = DateFormat('dd/MM/yy').format(_currentTime);

//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             leading: const CircleAvatar(
//               radius: 24,
//               backgroundImage: AssetImage('assets/images/profile.jpg'),
//             ),
//             title: Text(
//               _userName ?? 'Loading...',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(_userEmail ?? '-'),
//             trailing: const Icon(Icons.open_in_new),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text("Waktu saat ini :", style: TextStyle(color: Colors.grey)),
//                       const SizedBox(height: 8),
//                       Text(
//                         formattedTime,
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text("Tanggal saat ini :", style: TextStyle(color: Colors.grey)),
//                       const SizedBox(height: 8),
//                       Text(
//                         formattedDate,
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         const Text("Model Cepat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const Text("Mulai cepat, tanpa langkah-langkah rumit."),
//         const SizedBox(height: 16),
//         GridView.count(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           crossAxisCount: 4,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           children: [
//             _buildMenuItem(Icons.people, "Mahasiswa", onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const MahasiswaScreen()));
//             }),
//             _buildMenuItem(Icons.class_, "Kelas", onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const KelasScreen()));
//             }),
//             _buildMenuItem(Icons.date_range, "Akademik", onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const TahunAkademikScreen()));
//             }),
//             _buildMenuItem(Icons.bar_chart, "Rekap Nilai"),
//             _buildMenuItem(Icons.book, "Kurikulum"),
//             _buildMenuItem(Icons.menu_book, "Mata Kuliah"),
//             _buildMenuItem(Icons.person, "Pilih Dosen"),
//             _buildMenuItem(Icons.check_circle, "Presensi"),
//             _buildMenuItem(Icons.receipt_long, "Rekap KHS"),
//             _buildMenuItem(Icons.fact_check, "Rekap KRS"),
//           ],
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap ?? () {},
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.blue[800],
//             radius: 24,
//             child: Icon(icon, color: Colors.white, size: 20),
//           ),
//           const SizedBox(height: 6),
//           Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuPage(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             leading: const Icon(Icons.school, color: Colors.blue),
//             title: const Text('Tahun Akademik'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const TahunAkademikScreen()));
//             },
//           ),
//         ),
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             leading: const Icon(Icons.people, color: Colors.blue),
//             title: const Text('Kelas Mahasiswa'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const KelasScreen()));
//             },
//           ),
//         ),
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             leading: const Icon(Icons.people, color: Colors.blue),
//             title: const Text('Mahasiswa'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const MahasiswaScreen()));
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAccountPage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircleAvatar(
//             radius: 40,
//             backgroundImage: AssetImage('assets/images/profile.jpg'),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             _userName ?? 'Loading...',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             _userEmail ?? '-',
//           ),
//         ],
//       ),
//     );
//   }
// }
