import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_kelompok2/screens/dosen/kalender_page.dart';
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart';
import 'package:mobile_kelompok2/screens/dosen/tanggungan.dart';
import 'package:mobile_kelompok2/screens/dosen/detail_kelas.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// GANTI DENGAN BASE URL SERVERMU
const String baseUrl = 'https://ti054e01.agussbn.my.id/api/jadwal';

// --- 1. Model Data Mata Kuliah ---
class MataKuliah {
  final int id;
  final int idProdi;
  final String nama;
  final double sks;
  final int semester;

  MataKuliah({
    required this.id,
    required this.idProdi,
    required this.nama,
    required this.sks,
    required this.semester,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'],
      idProdi: json['id_prodi'],
      nama: json['nama'],
      sks: json['sks'].toDouble(), // Pastikan dikonversi ke double
      semester: json['semester'],
    );
  }
}

// ====== Placeholder Pages for Navigation ======
// Pastikan halaman-halaman ini didefinisikan di file terpisah dan diimpor dengan benar.
// Jika belum, placeholder ini akan digunakan.
class BimbinganPage extends StatelessWidget {
  const BimbinganPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Bimbingan')),
      body: const Center(child: Text('Konten Halaman Bimbingan')),
    );
  }
}

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Jadwal')),
      body: const Center(child: Text('Konten Halaman Jadwal')),
    );
  }
}

class PerkuliahanPage extends StatelessWidget {
  const PerkuliahanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Perkuliahan')),
      body: const Center(child: Text('Konten Halaman Perkuliahan')),
    );
  }
}

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Laporan')),
      body: const Center(child: Text('Konten Halaman Laporan')),
    );
  }
}

// Assuming BukaKelasPage is defined elsewhere, if not, create a placeholder
class BukaKelasPage extends StatelessWidget {
  const BukaKelasPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buka Kelas Baru')),
      body: const Center(child: Text('Formulir untuk membuka kelas baru')),
    );
  }
}

// Placeholder for MengajarHariIniPage
class MengajarHariIniPage extends StatelessWidget {
  final String userName;
  final int dosenId; // Added dosenId to MengajarHariIniPage

  const MengajarHariIniPage({super.key, required this.userName, required this.dosenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mengajar Hari Ini')),
      body: Center(child: Text('Detail jadwal mengajar untuk $userName (ID: $dosenId) hari ini.')),
    );
  }
}

class DashboardDosen extends StatefulWidget {
  final String userName;
  final int dosenId; // Tambahkan properti dosenId

  const DashboardDosen({super.key, required this.userName, required this.dosenId}); // Perbarui konstruktor

  @override
  State<DashboardDosen> createState() => _DashboardDosenState();
}

class _DashboardDosenState extends State<DashboardDosen> {
  int _currentIndex = 0;
  bool _showTasks = true;
  bool _hasJadwalHariIni = false;
  bool _hasTanggungan = false;
  List<MataKuliah> _mataKuliahList = []; // List untuk menyimpan data mata kuliah
  bool _isLoadingMatkul = true; // State untuk indikator loading mata kuliah

  // HATI-HATI: Token ini sebaiknya didapatkan dari SecureStorage, bukan hardcode
  final String _dosenToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';
  final String _apiUrlJadwal = '$baseUrl/jadwal'; // Menggunakan baseUrl yang sudah didefinisikan
  final String _apiUrlMatkul = '$baseUrl/matkul'; // API endpoint untuk daftar mata kuliah

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _fetchData(); // Mengambil data jadwal
    _fetchMataKuliah(); // Mengambil data mata kuliah
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        // Panggil API jadwal dan filter berdasarkan id_dosen
        Uri.parse('$_apiUrlJadwal?id_dosen=${widget.dosenId}'),
        headers: {
          'Authorization': 'Bearer $_dosenToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List jadwalList = data['data'];

        final today = DateTime.now();
        final formattedToday = DateFormat('yyyy-MM-dd').format(today);

        bool hasJadwalToday = false;
        bool hasOutstandingTasks = false;

        for (var item in jadwalList) {
          try {
            final itemDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(item['tanggal_jadwal']));
            if (itemDate == formattedToday) {
              hasJadwalToday = true;
            }
            if (item['status'] != null && item['status'].toLowerCase() == 'belum_selesai') {
              hasOutstandingTasks = true;
            }
          } catch (e) {
            debugPrint('Error parsing date for item: $item, error: $e');
          }
        }

        setState(() {
          _hasJadwalHariIni = hasJadwalToday;
          _hasTanggungan = hasOutstandingTasks;
        });
      } else {
        debugPrint('Gagal ambil data jadwal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat mengambil data jadwal: $e');
    }
  }

  // --- 2. Fungsi untuk Mengambil Data Mata Kuliah ---
  Future<void> _fetchMataKuliah() async {
    setState(() {
      _isLoadingMatkul = true; // Set loading true saat memulai fetch
    });
    try {
      final response = await http.get(
        Uri.parse(_apiUrlMatkul), // Mengambil semua mata kuliah
        headers: {
          'Authorization': 'Bearer $_dosenToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Pastikan struktur respons API Anda memiliki kunci 'data' yang berisi list mata kuliah
        if (data != null && data['data'] is List) {
          setState(() {
            _mataKuliahList = (data['data'] as List)
                .map((item) => MataKuliah.fromJson(item))
                .toList();
          });
        } else {
          debugPrint('Struktur respons API matkul tidak sesuai: $data');
        }
      } else {
        debugPrint('Gagal ambil data mata kuliah: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat mengambil data mata kuliah: $e');
    } finally {
      setState(() {
        _isLoadingMatkul = false; // Set loading false setelah selesai fetch
      });
    }
  }

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    String appBarTitle = '';
    PreferredSizeWidget? appBarWidget;

    switch (_currentIndex) {
      case 0: // Home / Dashboard View
        appBarWidget = _buildHomeAppBar();
        bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian status "Mengajar Hari Ini", "Tanggungan", "Kalender"
              LayoutBuilder(
                builder: (context, constraints) {
                  final double itemWidth = (constraints.maxWidth - 15.0) / 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: itemWidth / 110,
                    children: [
                      if (_hasJadwalHariIni)
                        _buildStatusCard(
                          'Mengajar Hari Ini',
                          const Color(0xFF90CAF9),
                          icon: Icons.star,
                          subtitle: 'Anda Memiliki Jadwal Hari Ini',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MengajarHariIniPage(userName: widget.userName, dosenId: widget.dosenId)),
                            );
                          },
                        ),
                      if (_hasTanggungan)
                        _buildStatusCard(
                          'Tanggungan',
                          const Color(0xFF191970),
                          icon: Icons.task_alt,
                          subtitle: 'Lihat Tanggungan Anda',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TanggunganPage(userName: widget.userName, dosenId: widget.dosenId)),
                            );
                          },
                        ),
                      _buildStatusCard(
                        'Kalender',
                        const Color(0xFF5F9EA0),
                        icon: Icons.calendar_month,
                        showCalendarIcon: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KalenderPage()),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32.0),
              _buildTaskSection(), // Bagian "All Tasks"
              const SizedBox(height: 32.0), // Spasi sebelum daftar mata kuliah
              // --- 3. Menampilkan Data Mata Kuliah ---
              Text(
                'Daftar Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _isLoadingMatkul
                  ? const Center(child: CircularProgressIndicator())
                  : _mataKuliahList.isEmpty
                      ? const Center(child: Text('Tidak ada mata kuliah tersedia.'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mataKuliahList.length,
                          itemBuilder: (context, index) {
                            final matkul = _mataKuliahList[index];
                            return _buildMatkulCard(matkul); // Gunakan kartu baru untuk mata kuliah
                          },
                        ),
            ],
          ),
        );
        break;
      case 1: // Tanggungan
        appBarTitle = 'Tanggungan Anda';
        bodyContent = TanggunganPage(userName: widget.userName, dosenId: widget.dosenId);
        break;
      case 2: // Ini seharusnya tidak akan tercapai karena FAB menangani navigasi secara langsung
        appBarTitle = 'Buat';
        bodyContent = const Center(child: Text('Buat Page Content'));
        break;
      case 3: // Search Page
        appBarTitle = 'Pencarian';
        bodyContent = Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari mahasiswa, jadwal, atau kelas...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text("Fitur pencarian belum tersedia."),
            ],
          ),
        );
        break;
      case 4: // Menu Page
        appBarTitle = 'Menu';
        bodyContent = ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Dosen'),
              subtitle: const Text('Lihat dan ubah informasi pribadi'),
              onTap: () {
                // Navigasi ke halaman profil dosen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              subtitle: const Text('Ubah preferensi aplikasi'),
              onTap: () {
                // Navigasi ke halaman pengaturan
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
        break;
      default:
        appBarTitle = 'Halaman Tidak Ditemukan';
        bodyContent = const Center(child: Text('Halaman belum tersedia'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentIndex == 0
          ? appBarWidget
          : AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              title: Text(
                appBarTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
      body: bodyContent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BukaKelasPage()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 120,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo_poliban.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 40);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POLITEKNIK NEGERI BANJARMASIN',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.userName,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () => _updateCurrentIndex(3),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.grey),
                  onPressed: () => _updateCurrentIndex(4),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildStatusCard(String title, Color color, {IconData? icon, String? subtitle, bool showCalendarIcon = false, VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(icon ?? Icons.sync, color: Colors.white.withOpacity(0.8), size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (subtitle != null && !showCalendarIcon)
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              if (showCalendarIcon)
                Text(DateFormat('dd MMM', 'id_ID').format(DateTime.now()), style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            IconButton(
              onPressed: () {
                setState(() {
                  _showTasks = !_showTasks;
                });
              },
              icon: Icon(_showTasks ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: _showTasks,
          child: Column(
            children: [
              _buildTaskCard('Bimbingan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BimbinganPage()))),
              _buildTaskCard('Jadwal', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JadwalPage()))),
              _buildTaskCard('Perkuliahan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerkuliahanPage()))),
              _buildTaskCard('Laporan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaporanPage()))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(String taskTitle, {VoidCallback? onTap}) {
    IconData iconData;
    switch (taskTitle) {
      case 'Bimbingan':
        iconData = Icons.supervisor_account;
        break;
      case 'Jadwal':
        iconData = Icons.calendar_today;
        break;
      case 'Perkuliahan':
        iconData = Icons.class_;
        break;
      case 'Laporan':
        iconData = Icons.description;
        break;
      default:
        iconData = Icons.check_circle_outline;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(iconData, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Expanded(child: Text(taskTitle, style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)))),
              const SizedBox(width: 12),
              const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // --- Fungsi untuk membangun kartu Mata Kuliah (baru) ---
  Widget _buildMatkulCard(MataKuliah matkul) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Implementasi navigasi ke halaman detail mata kuliah jika diperlukan
          debugPrint('Mata Kuliah ${matkul.nama} diklik!');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matkul.nama,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'SKS: ${matkul.sks.toInt()} | Semester: ${matkul.semester}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              // Anda bisa menambahkan info lain seperti nama prodi jika diambil dari API
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(0, Icons.home_outlined, 'Home'),
            _buildNavBarItem(1, Icons.assignment_turned_in_outlined, 'Tanggungan'),
            const SizedBox(width: 48), // Spacer for FAB
            _buildNavBarItem(3, Icons.search, 'Pencarian'),
            _buildNavBarItem(4, Icons.menu, 'Menu'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _updateCurrentIndex(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[400],
                size: 26,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}