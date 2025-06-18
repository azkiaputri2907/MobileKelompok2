import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Import KalenderPage dengan path yang diperbarui
import 'package:mobile_kelompok2/screens/dosen/kalender_page.dart';
// Import halaman baru MengajarHariIniPage
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart'; // Path diperbarui

// ====== Placeholder Pages for Navigation ======
// Definisi halaman-halaman ini dipindahkan ke sini agar dashboard.dart tetap self-contained
// Namun, jika halaman-halaman ini adalah file terpisah, Anda harus mengimpornya.

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

// MengajarHariIniPage sudah didefinisikan di file terpisah sekarang
// class MengajarHariIniPage extends StatelessWidget {
//   const MengajarHariIniPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Halaman Mengajar Hari Ini')),
//       body: const Center(child: Text('Konten Halaman Mengajar Hari Ini')),
//     );
//   }
// }

class TanggunganSayaPage extends StatelessWidget {
  const TanggunganSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tanggungan Saya')),
      body: const Center(child: Text('Konten Halaman Tanggungan Saya')),
    );
  }
}
// ===============================================


class DashboardDosen extends StatefulWidget {
  const DashboardDosen({super.key});

  @override
  State<DashboardDosen> createState() => _DashboardDosenState();
}

class _DashboardDosenState extends State<DashboardDosen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  // Callback untuk memperbarui indeks navigasi bawah
  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget yang akan ditampilkan di body berdasarkan _currentIndex
    Widget bodyContent;
    switch (_currentIndex) {
      case 0: // Home / Dashboard View
        bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian status "Mengajar Hari Ini", "Tanggungan", "Kalender"
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll GridView
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2 / 1, // Rasio aspek kartu
                children: [
                  _buildStatusCard(
                    'Mengajar Hari Ini',
                    const Color(0xFFC8A2C8),
                    icon: Icons.star, // Ikon bintang untuk Mengajar Hari Ini
                    subtitle: 'Anda Memiliki 1 Jadwal Hari Ini', // Subtitle baru ditambahkan
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MengajarHariIniPage()), // Navigasi ke halaman Mengajar Hari Ini
                      );
                    },
                  ),
                  _buildStatusCard(
                    'Tanggungan',
                    const Color(0xFFF9A888),
                    icon: Icons.task_alt, // Mengganti Icons.calendar_check dengan Icons.task_alt
                    subtitle: 'Lihat Tanggungan Anda', // Subtitle baru ditambahkan
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TanggunganSayaPage()),
                      );
                    },
                  ),
                  _buildStatusCard(
                    'Kalender',
                    const Color(0xFF90EE90),
                    icon: Icons.calendar_month,
                    showCalendarIcon: true, // Ikon kalender dan tanggal
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KalenderPage()), // Navigasi ke KalenderPage
                      );
                    },
                  ),
                  // _buildStatusCard('Cancel', const Color(0xFFF47B7C), icon: Icons.cancel), // Ikon silang untuk Cancel - tetap dikomentari
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    label: const Text('All Tasks', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Daftar tugas / Jadwal mengajar (sekarang dapat ditekan)
              _buildTaskCard(
                'Bimbingan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BimbinganPage()),
                  );
                },
              ),
              _buildTaskCard(
                'Jadwal',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JadwalPage()),
                  );
                },
              ),
              _buildTaskCard(
                'Perkuliahan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PerkuliahanPage()),
                  );
                },
              ),
              _buildTaskCard(
                'Laporan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPage()),
                  );
                },
              ),
            ],
          ),
        );
        break;
      case 1: // Tanggungan Page
        bodyContent = const Center(child: Text('Tanggungan Page Content'));
        break;
      case 2: // Buat Page
        bodyContent = const Center(child: Text('Buat Page Content'));
        break;
      case 3: // Search Page
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
        bodyContent = ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Dosen'),
              subtitle: const Text('Lihat dan ubah informasi pribadi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              subtitle: const Text('Ubah preferensi aplikasi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        );
        break;
      default:
        bodyContent = const Center(child: Text('Halaman belum tersedia'));
    }

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih untuk body
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar putih
        elevation: 0, // Tanpa shadow
        toolbarHeight: 120, // Menyesuaikan tinggi AppBar
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo, Nama Universitas, dan Nama Dosen
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_poliban.png', // Pastikan path ini benar
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'POLITEKNIK NEGERI BANJARMASIN',
                        style: TextStyle(
                          fontSize: 16, // Ukuran font disesuaikan
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Warna teks hitam
                        ),
                      ),
                      Text(
                        'Jamilatul Azkia Putri', // Nama Anda, kecil saja
                        style: TextStyle(
                          fontSize: 12, // Ukuran font lebih kecil
                          color: Colors.grey, // Warna teks abu-abu
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16), // Spasi setelah bagian logo/nama

              // Bar pencarian: ikon search, text field, ikon menu
              Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 24), // Ikon pencarian di kiri
                  const SizedBox(width: 8),
                  Expanded( // Search Bar di tengah
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100], // Warna latar belakang bar pencarian
                        borderRadius: BorderRadius.circular(20), // Sudut membulat
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none, // Menghilangkan border default TextField
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding internal
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.menu, color: Colors.grey, size: 24), // Ikon menu di kanan
                ],
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
      ),
      body: bodyContent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk tombol tambah di tengah bawah
          print('Add Task Floating Button pressed!');
        },
        backgroundColor: const Color(0xFFC8A2C8), // Warna ungu dari kartu "Ongoing"
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        shape: const CircleBorder(), // Membuat FAB berbentuk lingkaran
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Posisikan di tengah bawah
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // Memberikan lekukan untuk FAB
        notchMargin: 8.0, // Jarak lekukan
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: _currentIndex == 0 ? const Color(0xFF9FBADE) : Colors.grey),
              onPressed: () => _updateCurrentIndex(0),
            ),
            IconButton(
              icon: Icon(Icons.folder_copy, color: _currentIndex == 1 ? const Color(0xFF9FBADE) : Colors.grey),
              onPressed: () => _updateCurrentIndex(1),
            ),
            const SizedBox(width: 48), // Spacer untuk FloatingActionButton
            IconButton(
              icon: Icon(Icons.send, color: _currentIndex == 3 ? const Color(0xFF9FBADE) : Colors.grey),
              onPressed: () => _updateCurrentIndex(3),
            ),
            IconButton(
              icon: Icon(Icons.person, color: _currentIndex == 4 ? const Color(0xFF9FBADE) : Colors.grey),
              onPressed: () => _updateCurrentIndex(4),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu status (Mengajar Hari Ini, Tanggungan, Kalender, dll.)
  Widget _buildStatusCard(String title, Color color, {IconData? icon, String? subtitle, bool showCalendarIcon = false, VoidCallback? onTap}) {
    return Card(
      elevation: 0, // Tanpa shadow
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Sudut membulat
      ),
      child: InkWell( // Wrap Card dengan InkWell agar bisa ditekan
        onTap: onTap, // Gunakan callback onTap
        borderRadius: BorderRadius.circular(16.0), // Pastikan border radius sesuai
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child:
                    // Menampilkan ikon yang diberikan atau ikon kalender jika showCalendarIcon true
                    // Jika tidak ada ikon spesifik dan showCalendarIcon false, default ke Icons.sync
                    Icon(
                  icon ?? (showCalendarIcon ? Icons.calendar_month : Icons.sync),
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Menambahkan subtitle jika ada
              if (subtitle != null && !showCalendarIcon) // Tampilkan subtitle kecuali jika showCalendarIcon true
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12, // Ukuran font yang lebih kecil untuk subtitle
                  ),
                ),
              if (showCalendarIcon) // Menambahkan teks tanggal jika ikon kalender ditampilkan
                Text(
                  DateFormat('dd MMM', 'en_US').format(DateTime.now()), // Tanggal hari ini
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kartu tugas
  Widget _buildTaskCard(String taskTitle, {VoidCallback? onTap}) { // Tambahkan parameter onTap
    return Card(
      elevation: 0, // Tanpa shadow
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey[200]!, width: 1), // Border tipis
      ),
      child: InkWell( // Wrap Card dengan InkWell agar bisa ditekan
        onTap: onTap, // Gunakan callback onTap
        borderRadius: BorderRadius.circular(12.0), // Pastikan border radius sesuai
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.grey[400]), // Ikon checklist
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  taskTitle,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
                ),
              ),
              const SizedBox(width: 12),
              // Placeholder untuk avatar
              ClipOval(
                child: Image.network(
                  'https://placehold.co/30x30/cccccc/ffffff?text=U1',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_outline, size: 30, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              ClipOval(
                child: Image.network(
                  'https://placehold.co/30x30/999999/ffffff?text=U2',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_outline, size: 30, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
