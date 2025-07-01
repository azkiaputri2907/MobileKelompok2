import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tetap dibutuhkan jika ada formatting tanggal/waktu di fungsi lain
import 'dart:convert';
import 'package:http/http.dart' as http;

// Pastikan import ini menunjuk ke BukaKelasPage yang sudah dimodifikasi
import 'package:mobile_kelompok2/screens/auth/buka_kelas.dart';

// Import halaman-halaman admin yang spesifik
import 'package:mobile_kelompok2/screens/admin/presensi_kelas_list.dart';
import 'package:mobile_kelompok2/screens/admin/pegawai_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/status_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/provinsi_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/kotakabupaten_list_page.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';

// Hapus import dashboarddosen.dart jika AdminDashboard tidak menggunakannya
// import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart';

// Jika Anda memiliki model MataKuliah yang digunakan di tempat lain (misal di DosenDashboard),
// sebaiknya definisikan di file terpisah seperti models/mata_kuliah.dart
// dan impor di sini jika diperlukan oleh fungsionalitas lain.
// Untuk AdminDashboard ini, MataKuliah tidak lagi langsung digunakan.
// class MataKuliah { ... } // Hapus definisi ini dari sini


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // Fungsi tambahJadwalUntukDosen ini tidak dipanggil oleh tombol yang ada di UI AdminDashboard.
  // Jika Anda tidak menggunakannya, disarankan untuk menghapusnya agar kode lebih bersih.
  Future<void> tambahJadwalUntukDosen(BuildContext context) async {
    const url = 'https://ti054e01.agussbn.my.id/api/jadwal';
    // PENTING: Token ini HARUS didapatkan secara dinamis setelah login,
    // dan disimpan dengan aman (misal: flutter_secure_storage).
    const token = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "judul": "Kelas Pagi Algoritma",
          "tanggal_jadwal": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "jam_mulai": "08:00:00",
          "jam_selesai": "10:00:00",
          "id_dosen": 2, // <- sesuaikan ID dosen yang valid
          "id_matkul": 1, // <- sesuaikan ID mata kuliah yang valid
          "id_ruangan": 1, // <- sesuaikan ID ruangan yang valid
          "pertemuan_ke": 1,
        }),
      );

      debugPrint('Add Jadwal API Status: ${response.statusCode}');
      debugPrint('Add Jadwal API Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal berhasil ditambahkan!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambah jadwal: ${response.body}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error adding jadwal: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error koneksi saat menambah jadwal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.05;
    final double verticalPadding = screenSize.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF333333)),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFCECFB), Color(0xFFE0E7FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // === PENTING: Panggil BukaKelasPage tanpa argumen selectedMatkul ===
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BukaKelasPage()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Mata Kuliah"), // Mengubah label
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: const Color(0xFF333333),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 26, color: Color(0xFF333333)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur pencarian belum diimplementasikan.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  children: [
                    // Menggunakan _buildAdminCard yang sudah disesuaikan
                    _buildAdminCard(
                      context,
                      title: 'Pegawai',
                      infoText: 'Mengelola data pegawai',
                      icon: Icons.people,
                      cardColor: const Color(0xFF90CAF9),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildAdminCard(
                      context,
                      title: 'Kota/Kabupaten',
                      infoText: 'Mengelola data kota dan kabupaten',
                      icon: Icons.location_city,
                      cardColor: const Color(0xFF191970),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const KotaKabupatenListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildAdminCard(
                      context,
                      title: 'Provinsi',
                      infoText: 'Mengelola data provinsi',
                      icon: Icons.map,
                      cardColor: const Color(0xFF5F9EA0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProvinsiListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildAdminCard(
                      context,
                      title: 'Status',
                      infoText: 'Mengelola status (misal: aktif, non-aktif)',
                      icon: Icons.info_outline,
                      cardColor: Colors.teal,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildAdminCard(
                      context,
                      title: 'Presensi Kelas',
                      infoText: 'Melihat dan mengelola presensi kelas',
                      icon: Icons.check_circle_outline,
                      cardColor: Colors.blue,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PresensiKelasListPage()));
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Widget _buildAdminCard yang sudah disesuaikan
  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String infoText,
    required IconData icon,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardPadding = screenWidth * 0.05;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(cardPadding),
          width: double.infinity,
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 40),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    infoText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home_outlined, 'Home', true),
          _buildNavBarItem(Icons.folder_open, 'Data', false),
          _buildNavBarItem(Icons.notifications_none, 'Notifikasi', false),
          _buildNavBarItem(Icons.person_outline, 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Implementasi navigasi jika dibutuhkan
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF6A5AE0) : Colors.grey[400],
                size: 26,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF6A5AE0) : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}