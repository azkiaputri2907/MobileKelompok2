import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart'; // <--- Tambahkan ini

// Asumsi kelas DashboardDosen ada di file lain atau perlu didefinisikan.
// Untuk tujuan demonstrasi, saya akan menambahkan placeholder di sini.
// class DashboardDosen extends StatelessWidget {
//   const DashboardDosen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard Dosen'),
//         backgroundColor: const Color(0xFF90CAF9),
//         foregroundColor: Colors.white,
//       ),
//       body: const Center(
//         child: Text(
//           'Ini adalah halaman Dashboard Dosen',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

class TanggunganPage extends StatelessWidget {
  const TanggunganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang yang lebih lembut
      body: Column( // Menggunakan Column untuk menempatkan tombol di atas
        children: [
          // Tombol Kembali ke Beranda (hanya ikon)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Align(
              alignment: Alignment.topLeft, // Menempatkan tombol di kiri atas
              child: ElevatedButton( // Menggunakan ElevatedButton biasa karena tidak ada label teks
                onPressed: () {
                  // Menggunakan Navigator.pushAndRemoveUntil untuk kembali ke DashboardDosen
                  // dan menghapus semua rute di atasnya.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardDosen() ),
                    (Route<dynamic> route) => false, // Ini akan menghapus semua rute sebelumnya
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90CAF9), // Warna tombol yang serasi
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12), // Sesuaikan padding untuk ikon saja
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Icon(Icons.arrow_back), // Hanya ikon panah kembali
              ),
            ),
          ),
          // Judul halaman Tanggungan Anda
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       'Tanggungan Anda',
          //       style: TextStyle(
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xFF37474F),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16), // Spasi setelah judul

          Expanded( // Memungkinkan daftar card untuk mengambil sisa ruang yang tersedia
            child: SingleChildScrollView( // Memastikan konten dapat digulir jika terlalu panjang
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal untuk kartu
                child: Column(
                  children: [
                    _buildTanggunganCard(
                      context,
                      'Anda belum mengisi realisasi perkuliahan hari ini',
                      'Lihat detail',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Melihat detail realisasi perkuliahan...')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTanggunganCard(
                      context,
                      'Anda belum mengisi presensi mahasiswa hari ini',
                      'Lihat detail',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Melihat detail presensi mahasiswa...')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTanggunganCard(
                      context,
                      'Anda belum mengisi nilai mahasiswa hari ini',
                      'Lihat detail',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Melihat detail nilai mahasiswa...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTanggunganCard(BuildContext context, String text, String buttonText, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9FBADE), // Warna tombol detail
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
