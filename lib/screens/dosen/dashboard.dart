import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Import KalenderPage dengan path yang diperbarui
import 'package:mobile_kelompok2/screens/dosen/kalender_page.dart';
// Import halaman baru MengajarHariIniPage dan ClassDetails
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart'; // Path diperbarui, ClassDetails ada di sini
import 'package:mobile_kelompok2/screens/dosen/tanggungan.dart'; // Mengganti tanggungan.dart menjadi tanggungan_page.dart
// Import DetailKelasPage
import 'package:mobile_kelompok2/screens/dosen/detail_kelas.dart';
import 'package:mobile_kelompok2/screens/auth/login_page.dart';


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

class DashboardDosen extends StatefulWidget {
  const DashboardDosen({super.key});

  @override
  State<DashboardDosen> createState() => _DashboardDosenState();
}

class _DashboardDosenState extends State<DashboardDosen> {
  int _currentIndex = 0;
  bool _showTasks = true; // State baru untuk mengontrol visibilitas task cards

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
    String appBarTitle = ''; // Default title for other pages
    PreferredSizeWidget? appBarWidget; // Nullable AppBar to control its visibility

    switch (_currentIndex) {
      case 0: // Home / Dashboard View
        appBarWidget = _buildHomeAppBar();
        bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian status "Mengajar Hari Ini", "Tanggungan", "Kalender"
              // Menggunakan LayoutBuilder untuk mendapatkan ukuran maksimum yang tersedia
              LayoutBuilder(
                builder: (context, constraints) {
                  final double itemWidth = (constraints.maxWidth - 15.0) / 2; // Hitung lebar item
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll GridView
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    // Sesuaikan childAspectRatio berdasarkan lebar item dan tinggi yang diinginkan
                    // Tinggi yang diinginkan sekitar 100-120 untuk menghindari overflow
                    childAspectRatio: itemWidth / 110, // Menyesuaikan tinggi kartu
                    children: [
                      _buildStatusCard(
                        'Mengajar Hari Ini',
                        const Color(0xFF90CAF9),
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
                        const Color(0xFF191970),
                        icon: Icons.task_alt, // Mengganti Icons.calendar_check dengan Icons.task_alt
                        subtitle: 'Lihat Tanggungan Anda', // Subtitle baru ditambahkan
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TanggunganPage()), // Mengganti TanggunganSayaPage
                          );
                        },
                      ),
                      _buildStatusCard(
                        'Kalender',
                        const Color(0xFF5F9EA0),
                        icon: Icons.calendar_month,
                        showCalendarIcon: true, // Ikon kalender dan tanggal
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KalenderPage()), // Navigasi ke KalenderPage
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showTasks = !_showTasks; // Toggle visibilitas tasks
                      });
                    },
                    icon: Icon(
                      _showTasks ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Ikon panah sesuai status
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Daftar tugas / Jadwal mengajar (sekarang dapat ditekan)
              // Dibungkus dengan Visibility untuk kontrol sembunyi/tampil
              Visibility(
                visible: _showTasks, // Berdasarkan state _showTasks
                child: Column(
                  children: [
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
              ),
            ],
          ),
        );
        break;
      case 1:
        appBarTitle = 'Tanggungan Anda'; // <--- TAMBAHKAN INI
        bodyContent = const TanggunganPage();
        break;
      case 2: // Buat Page (FAB) - Ini tidak akan pernah tercapai karena FAB menangani navigasi secara langsung
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Menghapus semua route sebelumnya
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
      backgroundColor: Colors.white, // Latar belakang putih untuk body
      appBar: _currentIndex == 0
          ? appBarWidget
          : AppBar(
              backgroundColor: const Color(0xFF90CAF9), // Ubah warna AppBar untuk halaman non-home
              elevation: 0,
              title: Text(
                appBarTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ubah warna teks AppBar untuk halaman non-home
                ),
              ),
              centerTitle: true, // Pusatkan judul halaman
              automaticallyImplyLeading: false, // Menghilangkan tombol back default
            ),
      body: bodyContent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke JadwalPerkuliahanPage yang ada di file detail_kelas.dart
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MengajarHariIniPage()), // Navigasi ke halaman Mengajar Hari Ini
          );
        },
        backgroundColor: const Color(0xFF00BCD4), // Warna ungu dari kartu "Ongoing"
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
              icon: Icon(Icons.search, color: _currentIndex == 3 ? const Color(0xFF9FBADE) : Colors.grey),
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

  // Fungsi untuk membangun AppBar khusus Home
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
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
                Expanded( // Use Expanded to prevent overflow of text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'POLITEKNIK NEGERI BANJARMASIN',
                        style: TextStyle(
                          fontSize: 16, // Ukuran font disesuaikan
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Warna teks hitam
                        ),
                        maxLines: 1, // Ensure text doesn't wrap and cause overflow
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                      ),
                      Text(
                        'Jamilatul Azkia Putri', // Nama Anda, kecil saja
                        style: TextStyle(
                          fontSize: 12, // Ukuran font lebih kecil
                          color: Colors.grey, // Warna teks abu-abu
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Removed Spacer and added fixed SizedBox to control spacing
                const SizedBox(width: 10), // Adjust spacing
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey, size: 24),
                  onPressed: () {
                    // Aksi saat ikon pencarian ditekan
                    _updateCurrentIndex(3); // Navigasi ke halaman pencarian
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.grey, size: 24),
                  onPressed: () {
                    // Aksi saat ikon menu ditekan
                    _updateCurrentIndex(4); // Navigasi ke halaman menu
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), // Spasi setelah bagian logo/nama
          ],
        ),
      ),
      automaticallyImplyLeading: false, // Menghilangkan tombol back default
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
      child: InkWell(
        // Wrap Card dengan InkWell agar bisa ditekan
        onTap: onTap, // Gunakan callback onTap
        borderRadius: BorderRadius.circular(16.0), // Pastikan border radius sesuai
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
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
              // Use Spacer to push the title/subtitle to the bottom, ensuring enough space
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1, // Prevent overflow for title
                overflow: TextOverflow.ellipsis,
              ),
              // Menambahkan subtitle jika ada
              if (subtitle != null && !showCalendarIcon) // Tampilkan subtitle kecuali jika showCalendarIcon true
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12, // Ukuran font yang lebih kecil untuk subtitle
                  ),
                  maxLines: 1, // Prevent overflow for subtitle
                  overflow: TextOverflow.ellipsis,
                ),
              if (showCalendarIcon) // Menambahkan teks tanggal jika ikon kalender ditampilkan
                Text(
                  DateFormat('dd MMM', 'id_ID').format(DateTime.now()), // Tanggal hari ini
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kartu tugas
  Widget _buildTaskCard(String taskTitle, {VoidCallback? onTap}) {
    IconData iconData;
    // Menentukan ikon berdasarkan taskTitle
    switch (taskTitle) {
      case 'Bimbingan':
        iconData = Icons.supervisor_account; // Ikon bimbingan/konsultasi
        break;
      case 'Jadwal':
        iconData = Icons.calendar_today; // Ikon kalender/jadwal
        break;
      case 'Perkuliahan':
        iconData = Icons.class_; // Ikon kelas/perkuliahan
        break;
      case 'Laporan':
        iconData = Icons.description; // Ikon dokumen/laporan
        break;
      default:
        iconData = Icons.check_circle_outline; // Default ikon jika tidak ada yang cocok
    }

    return Card(
      elevation: 0, // Tanpa shadow
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey[200]!, width: 1), // Border tipis
      ),
      child: InkWell(
        // Wrap Card dengan InkWell agar bisa ditekan
        onTap: onTap, // Gunakan callback onTap
        borderRadius: BorderRadius.circular(12.0), // Pastikan border radius sesuai
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(iconData, color: Colors.grey[600]), // Menggunakan ikon yang ditentukan
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  taskTitle,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
                  maxLines: 1, // Prevent text overflow
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12), // Biarkan ini jika ingin panah tetap di kanan
              const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}