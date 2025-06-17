import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Import TableCalendar telah dihapus sepenuhnya karena tidak lagi digunakan

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
              // Bagian status "Ongoing", "In Process", dll.
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
                    showCalendarIcon: false, // Tidak menampilkan tanggal di sini jika ini bukan kartu "Complet"
                  ),
                  _buildStatusCard(
                    'Tanggungan',
                    const Color(0xFFF9A888),
                    icon: Icons.task_alt, // Mengganti Icons.calendar_check dengan Icons.task_alt
                    showCalendarIcon: false, // Tidak menampilkan tanggal di sini jika ini bukan kartu "Complet"
                  ),
                  _buildStatusCard('Kalender', const Color(0xFF90EE90), icon: Icons.calendar_month, showCalendarIcon: true), // Ikon kalender dan tanggal
                 // _buildStatusCard('Cancel', const Color(0xFFF47B7C), icon: Icons.cancel), // Ikon silang untuk Cancel
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Color(0xFF37474F)),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    label: const Text('All Tasks', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Daftar tugas / Jadwal mengajar
              _buildTaskCard('Dashboard Design'),
              _buildTaskCard('Mobile App Design'),
              _buildTaskCard('Wireframe Design'),
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
        toolbarHeight: 100, // Menyesuaikan tinggi AppBar
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bar pencarian baru: ikon search, text field, ikon menu
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
              const SizedBox(height: 16), // Spasi ke teks "Today"
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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

  // Widget untuk kartu status (Ongoing, In Process, dll.)
  Widget _buildStatusCard(String title, Color color, {IconData? icon, bool showCalendarIcon = false}) {
    return Card(
      elevation: 0, // Tanpa shadow
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Sudut membulat
      ),
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
    );
  }

  // Widget untuk kartu tugas
  Widget _buildTaskCard(String taskTitle) {
    return Card(
      elevation: 0, // Tanpa shadow
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey[200]!, width: 1), // Border tipis
      ),
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
    );
  }
}
