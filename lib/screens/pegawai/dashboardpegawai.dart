// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// // Import halaman-halaman yang relevan untuk pegawai
// import 'package:mobile_kelompok2/screens/auth/login_page.dart'; // Tetap gunakan login_page
// import 'package:mobile_kelompok2/screens/pegawai/tugas_page.dart'; // Halaman baru untuk tugas hari ini
// import 'package:mobile_kelompok2/screens/pegawai/cuti_page.dart'; // Halaman baru untuk cuti dan izin
// import 'package:mobile_kelompok2/screens/pegawai/kalender_page.dart'; // Halaman kalender pegawai

// // ====== Placeholder Pages for Navigation ======
// // Definisi halaman-halaman ini dipindahkan ke sini agar dashboard.dart tetap self-contained
// // Namun, jika halaman-halaman ini adalah file terpisah, Anda harus mengimpornya.

// // Pastikan nama kelas sesuai dengan yang diimpor di atas
// // Jika Anda sudah memiliki file tugas_page.dart, cuti_page.dart, dan kalender_page.dart,
// // maka Anda bisa menghapus placeholder ini dan pastikan import di atas mengarah ke file yang benar.

// class TugasHariIniPage extends StatelessWidget {
//   const TugasHariIniPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Tugas Hari Ini')),
//       body: const Center(child: Text('Konten Halaman Tugas Hari Ini')),
//     );
//   }
// }

// class CutiIzinPage extends StatelessWidget {
//   const CutiIzinPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Cuti & Izin')),
//       body: const Center(child: Text('Konten Halaman Cuti & Izin')),
//     );
//   }
// }

// class KalenderPegawaiPage extends StatelessWidget {
//   const KalenderPegawaiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Kalender Pegawai')),
//       body: const Center(child: Text('Konten Halaman Kalender Pegawai')),
//     );
//   }
// }

// class PengajuanCutiPage extends StatelessWidget {
//   const PengajuanCutiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Pengajuan Cuti')),
//       body: const Center(child: Text('Konten Halaman Pengajuan Cuti')),
//     );
//   }
// }

// class DataKehadiranPage extends StatelessWidget {
//   const DataKehadiranPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Data Kehadiran')),
//       body: const Center(child: Text('Konten Halaman Data Kehadiran')),
//     );
//   }
// }

// class PengajuanLemburPage extends StatelessWidget {
//   const PengajuanLemburPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Pengajuan Lembur')),
//       body: const Center(child: Text('Konten Halaman Pengajuan Lembur')),
//     );
//   }
// }

// class InventarisKantorPage extends StatelessWidget {
//   const InventarisKantorPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Inventaris Kantor')),
//       body: const Center(child: Text('Konten Halaman Inventaris Kantor')),
//     );
//   }
// }

// class DashboardPegawai extends StatefulWidget {
//   const DashboardPegawai({super.key});

//   @override
//   State<DashboardPegawai> createState() => _DashboardPegawaiState();
// }

// class _DashboardPegawaiState extends State<DashboardPegawai> {
//   int _currentIndex = 0;
//   bool _showTasks = true; // State untuk mengontrol visibilitas task cards

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('id_ID', null);
//   }

//   // Callback untuk memperbarui indeks navigasi bawah
//   void _updateCurrentIndex(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget bodyContent;
//     String appBarTitle = '';
//     PreferredSizeWidget? appBarWidget;

//     switch (_currentIndex) {
//       case 0: // Home / Dashboard View
//         appBarWidget = _buildHomeAppBar();
//         bodyContent = SingleChildScrollView(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Bagian status "Tugas Hari Ini", "Cuti & Izin", "Kalender Pegawai"
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final double itemWidth = (constraints.maxWidth - 15.0) / 2;
//                   return GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15.0,
//                     mainAxisSpacing: 15.0,
//                     childAspectRatio: itemWidth / 110,
//                     children: [
//                       _buildStatusCard(
//                         'Tugas Hari Ini',
//                         const Color(0xFF4CAF50), // Warna hijau untuk tugas
//                         icon: Icons.assignment,
//                         subtitle: 'Anda Memiliki 2 Tugas Hari Ini',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const TugasHariIniPage()),
//                           );
//                         },
//                       ),
//                       _buildStatusCard(
//                         'Cuti & Izin',
//                         const Color(0xFFF44336), // Warna merah untuk cuti/izin
//                         icon: Icons.event_busy,
//                         subtitle: 'Ajukan atau Cek Status Cuti',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const CutiIzinPage()),
//                           );
//                         },
//                       ),
//                       _buildStatusCard(
//                         'Kalender Pegawai',
//                         const Color(0xFF2196F3), // Warna biru untuk kalender
//                         icon: Icons.calendar_month,
//                         showCalendarIcon: true,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const KalenderPegawaiPage()),
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 32.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'All Tasks',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _showTasks = !_showTasks;
//                       });
//                     },
//                     icon: Icon(
//                       _showTasks ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Visibility(
//                 visible: _showTasks,
//                 child: Column(
//                   children: [
//                     _buildTaskCard(
//                       'Pengajuan Cuti',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const PengajuanCutiPage()),
//                         );
//                       },
//                     ),
//                     _buildTaskCard(
//                       'Data Kehadiran',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const DataKehadiranPage()),
//                         );
//                       },
//                     ),
//                     _buildTaskCard(
//                       'Pengajuan Lembur',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const PengajuanLemburPage()),
//                         );
//                       },
//                     ),
//                     _buildTaskCard(
//                       'Inventaris Kantor',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const InventarisKantorPage()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//         break;
//       case 1: // Cuti & Izin Page
//         appBarTitle = 'Cuti & Izin Anda';
//         bodyContent = const CutiIzinPage();
//         break;
//       case 2: // Buat Page (FAB) - Ini tidak akan pernah tercapai karena FAB menangani navigasi secara langsung
//         appBarTitle = 'Buat';
//         bodyContent = const Center(child: Text('Buat Page Content'));
//         break;
//       case 3: // Search Page
//         appBarTitle = 'Pencarian';
//         bodyContent = Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: const [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Cari pegawai, dokumen, atau aset...',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text("Fitur pencarian belum tersedia."),
//             ],
//           ),
//         );
//         break;
//       case 4: // Menu Page
//         appBarTitle = 'Menu';
//         bodyContent = ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Profil Pegawai'),
//               subtitle: const Text('Lihat dan ubah informasi pribadi'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Pengaturan'),
//               subtitle: const Text('Ubah preferensi aplikasi'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Keluar'),
//               onTap: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginPage()),
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         );
//         break;
//       default:
//         appBarTitle = 'Halaman Tidak Ditemukan';
//         bodyContent = const Center(child: Text('Halaman belum tersedia'));
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _currentIndex == 0
//           ? appBarWidget
//           : AppBar(
//               backgroundColor: const Color(0xFF42A5F5), // Warna AppBar untuk halaman non-home
//               elevation: 0,
//               title: Text(
//                 appBarTitle,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               centerTitle: true,
//               automaticallyImplyLeading: false,
//             ),
//       body: bodyContent,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Aksi untuk FAB, misalnya menuju halaman pengajuan baru
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const PengajuanCutiPage()), // Contoh: Navigasi ke Pengajuan Cuti
//           );
//         },
//         backgroundColor: const Color(0xFF00C853), // Warna hijau untuk FAB
//         child: const Icon(Icons.add, color: Colors.white, size: 30),
//         shape: const CircleBorder(),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.white,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.home, color: _currentIndex == 0 ? const Color(0xFF42A5F5) : Colors.grey),
//               onPressed: () => _updateCurrentIndex(0),
//             ),
//             IconButton(
//               icon: Icon(Icons.folder_copy, color: _currentIndex == 1 ? const Color(0xFF42A5F5) : Colors.grey),
//               onPressed: () => _updateCurrentIndex(1),
//             ),
//             const SizedBox(width: 48), // Spacer for FloatingActionButton
//             IconButton(
//               icon: Icon(Icons.search, color: _currentIndex == 3 ? const Color(0xFF42A5F5) : Colors.grey),
//               onPressed: () => _updateCurrentIndex(3),
//             ),
//             IconButton(
//               icon: Icon(Icons.person, color: _currentIndex == 4 ? const Color(0xFF42A5F5) : Colors.grey),
//               onPressed: () => _updateCurrentIndex(4),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Fungsi untuk membangun AppBar khusus Home
//   PreferredSizeWidget _buildHomeAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       toolbarHeight: 120,
//       title: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Logo, Nama Universitas, dan Nama Pegawai
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/logo_poliban.png', // Pastikan path ini benar
//                   height: 40,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'POLITEKNIK NEGERI BANJARMASIN',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         'Jamilatul Azkia Putri', // Nama Pegawai
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 IconButton(
//                   icon: const Icon(Icons.search, color: Colors.grey, size: 24),
//                   onPressed: () {
//                     _updateCurrentIndex(3);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.menu, color: Colors.grey, size: 24),
//                   onPressed: () {
//                     _updateCurrentIndex(4);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       automaticallyImplyLeading: false,
//     );
//   }

//   // Widget untuk kartu status (Tugas Hari Ini, Cuti & Izin, Kalender Pegawai, dll.)
//   Widget _buildStatusCard(String title, Color color, {IconData? icon, String? subtitle, bool showCalendarIcon = false, VoidCallback? onTap}) {
//     return Card(
//       elevation: 0,
//       color: color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Icon(
//                   icon ?? (showCalendarIcon ? Icons.calendar_month : Icons.sync),
//                   color: Colors.white.withOpacity(0.8),
//                   size: 20,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               if (subtitle != null && !showCalendarIcon)
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 12,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               if (showCalendarIcon)
//                 Text(
//                   DateFormat('dd MMM', 'id_ID').format(DateTime.now()),
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 14,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget untuk kartu tugas
//   Widget _buildTaskCard(String taskTitle, {VoidCallback? onTap}) {
//     IconData iconData;
//     switch (taskTitle) {
//       case 'Pengajuan Cuti':
//         iconData = Icons.next_plan; // Ikon pengajuan cuti
//         break;
//       case 'Data Kehadiran':
//         iconData = Icons.bar_chart; // Ikon data kehadiran
//         break;
//       case 'Pengajuan Lembur':
//         iconData = Icons.access_time_filled; // Ikon pengajuan lembur
//         break;
//       case 'Inventaris Kantor':
//         iconData = Icons.business_center; // Ikon inventaris kantor
//         break;
//       default:
//         iconData = Icons.check_circle_outline;
//     }

//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 12.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//         side: BorderSide(color: Colors.grey[200]!, width: 1),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Icon(iconData, color: Colors.grey[600]),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   taskTitle,
//                   style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }