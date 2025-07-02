import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar

// Pastikan import ini menunjuk ke BukaKelasPage yang sudah dimodifikasi
import 'package:mobile_kelompok2/screens/auth/buka_kelas.dart';

// Import halaman-halaman admin yang spesifik
import 'package:mobile_kelompok2/screens/admin/presensi_kelas_list.dart';
import 'package:mobile_kelompok2/screens/admin/pegawai_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/status_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/provinsi_list_page.dart';
import 'package:mobile_kelompok2/screens/admin/kotakabupaten_list_page.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';

class AdminDashboard extends StatefulWidget {
  final String userName; // Tambahkan properti userName

  const AdminDashboard({super.key, required this.userName}); // Perbarui konstruktor

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Tambahkan variabel untuk kalender
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; // Nullable, karena awalnya tidak ada yang terpilih

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Set tanggal terpilih awal ke tanggal hari ini
  }

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
        title: Text( // Gunakan Text widget biasa untuk judul
          'Selamat Datang Admin Pegawai', // Menghilangkan tanda seru
          style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 18),
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
              // ==================== KALENDER DAN KARTU ADMIN SEKARANG BERGULIR BERSAMA ====================
              Expanded( // Expanded membungkus ListView agar ListView mengambil sisa ruang
                child: ListView( // ListView tunggal untuk semua konten yang dapat digulir
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding), // Padding diterapkan di sini
                  children: [
                    // Kalender
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          debugPrint('Tanggal terpilih: $selectedDay');
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF333333)),
                          rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF333333)),
                          titleTextStyle: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFF191970),
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(color: Colors.white),
                          weekendTextStyle: const TextStyle(color: Colors.red),
                          holidayTextStyle: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Jarak antara kalender dan kartu pertama

                    // Kartu Admin
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
                    const SizedBox(height: 80), // Jarak padding di bagian bawah
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

  // Widget _buildAdminCard dan _buildBottomNavBar tetap sama
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