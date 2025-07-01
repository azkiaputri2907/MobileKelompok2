import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_kelompok2/screens/auth/buka_kelas.dart';

import 'package:mobile_kelompok2/screens/admin/presensi_kelas_list.dart';
import 'package:mobile_kelompok2/screens/admin/pegawai_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/status_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/provinsi_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/kotakabupaten_list_page.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';
import 'package:mobile_kelompok2/screens/auth/buka_kelas.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> tambahJadwalUntukDosen(BuildContext context) async {
    const url = 'https://ti054e01.agussbn.my.id/api/jadwal';
    const token = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "judul": "Kelas Pagi Algoritma",
        "tanggal": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "jam_mulai": "08:00",
        "jam_selesai": "10:00",
        "id_dosen": 2 // <- sesuaikan ID dosen yang valid
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal berhasil ditambahkan!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah jadwal: ${response.body}')),
      );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BukaKelasPage()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Jadwal Dosen"),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
                    ),

                    IconButton(
                      icon: const Icon(Icons.search, size: 26, color: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  children: [
                    _buildProjectCard(
                      context,
                      title: 'Pegawai',
                      tasksCompleted: 12,
                      totalTasks: 12,
                      avatars: const [
                        'https://placehold.co/40x40/FF69B4/FFFFFF?text=A',
                        'https://placehold.co/40x40/DA70D6/FFFFFF?text=B',
                      ],
                      progress: 1.0,
                      cardColor: const Color(0xFF90CAF9),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProjectCard(
                      context,
                      title: 'Kota/Kabupaten',
                      tasksCompleted: 2,
                      totalTasks: 8,
                      avatars: const ['https://placehold.co/40x40/8A2BE2/FFFFFF?text=D'],
                      progress: 0.25,
                      cardColor: const Color(0xFF191970),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const KotaKabupatenListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProjectCard(
                      context,
                      title: 'Provinsi',
                      tasksCompleted: 4,
                      totalTasks: 7,
                      avatars: const [
                        'https://placehold.co/40x40/FFD700/FFFFFF?text=E',
                        'https://placehold.co/40x40/FFA500/FFFFFF?text=F',
                      ],
                      progress: 4 / 7,
                      cardColor: const Color(0xFF5F9EA0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProvinsiListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProjectCard(
                      context,
                      title: 'Status',
                      tasksCompleted: 1,
                      totalTasks: 1,
                      avatars: const ['https://placehold.co/40x40/4CAF50/FFFFFF?text=G'],
                      progress: 1.0,
                      cardColor: Colors.teal,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusListPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProjectCard(
                      context,
                      title: 'Presensi',
                      tasksCompleted: 1,
                      totalTasks: 1,
                      avatars: const ['https://placehold.co/40x40/2196F3/FFFFFF?text=H'],
                      progress: 1.0,
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

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required int tasksCompleted,
    required int totalTasks,
    required List<String> avatars,
    required double progress,
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
            children: [
              Row(
                children: avatars.map((avatarUrl) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, color: Colors.grey, size: 24);
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(
                '$tasksCompleted/$totalTasks tasks • ${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
          _buildNavBarItem(Icons.folder_open, 'Projects', false),
          _buildNavBarItem(Icons.notifications_none, 'Notifications', false),
          _buildNavBarItem(Icons.person_outline, 'Profile', false),
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
