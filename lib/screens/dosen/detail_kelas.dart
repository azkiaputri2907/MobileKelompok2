import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk DateFormat
import 'package:intl/date_symbol_data_local.dart'; // Import untuk inisialisasi lokal
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart';
import 'package:mobile_kelompok2/screens/dosen/peserta.dart'; // Import halaman Peserta Kelas (sesuai permintaan)
import 'package:mobile_kelompok2/screens/dosen/presensi.dart'; // Import halaman Presensi Kelas (sesuai permintaan)
// import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart'; // Tidak perlu diimport jika ClassDetails ada di sini

// Kelas model data untuk Detail Kelas
// Pastikan ini ada di file yang sama atau di file terpisah yang diimpor
class ClassDetails {
  final String programStudi;
  final String mataKuliah;
  final String kurikulum;
  final String kapasitas;
  final String periode;
  final String namaKelas;
  final String sistemKuliah;
  final String sesi;
  final String metode;
  final String tanggalJadwal;
  final String ruangKuliah;
  final String waktuSelesai;
  final String keteranganRuangKuliah;
  final String? jenisPertemuan; // Bisa null
  final String urlKuliahOnline;
  final String? status; // Bisa null

  ClassDetails({
    required this.programStudi,
    required this.mataKuliah,
    required this.kurikulum,
    required this.kapasitas,
    required this.periode,
    required this.namaKelas,
    required this.sistemKuliah,
    required this.sesi,
    required this.metode,
    required this.tanggalJadwal,
    required this.ruangKuliah,
    required this.waktuSelesai,
    required this.keteranganRuangKuliah,
    this.jenisPertemuan,
    required this.urlKuliahOnline,
    this.status,
  });

  // Metode copyWith untuk memudahkan update objek
  ClassDetails copyWith({
    String? programStudi,
    String? mataKuliah,
    String? kurikulum,
    String? kapasitas,
    String? periode,
    String? namaKelas,
    String? sistemKuliah,
    String? sesi,
    String? metode,
    String? tanggalJadwal,
    String? ruangKuliah,
    String? waktuSelesai,
    String? keteranganRuangKuliah,
    String? jenisPertemuan,
    String? urlKuliahOnline,
    String? status,
  }) {
    return ClassDetails(
      programStudi: programStudi ?? this.programStudi,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      kurikulum: kurikulum ?? this.kurikulum,
      kapasitas: kapasitas ?? this.kapasitas,
      periode: periode ?? this.periode,
      namaKelas: namaKelas ?? this.namaKelas,
      sistemKuliah: sistemKuliah ?? this.sistemKuliah,
      sesi: sesi ?? this.sesi,
      metode: metode ?? this.metode,
      tanggalJadwal: tanggalJadwal ?? this.tanggalJadwal,
      ruangKuliah: ruangKuliah ?? this.ruangKuliah,
      waktuSelesai: waktuSelesai ?? this.waktuSelesai,
      keteranganRuangKuliah: keteranganRuangKuliah ?? this.keteranganRuangKuliah,
      jenisPertemuan: jenisPertemuan ?? this.jenisPertemuan,
      urlKuliahOnline: urlKuliahOnline ?? this.urlKuliahOnline,
      status: status ?? this.status,
    );
  }
}

// Placeholder pages for Drawer navigation.
// Dalam aplikasi nyata, halaman-halaman ini sebaiknya berada di file terpisah
// dan diimpor di sini.
class JadwalPerkuliahanPage extends StatelessWidget {
  const JadwalPerkuliahanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Perkuliahan')),
      body: const Center(child: Text('Konten Jadwal Perkuliahan')),
    );
  }
}

class NilaiPerkuliahanPage extends StatelessWidget {
  const NilaiPerkuliahanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nilai Perkuliahan')),
      body: const Center(child: Text('Konten Nilai Perkuliahan')),
    );
  }
}
// End of placeholder pages

class DetailKelasPage extends StatefulWidget {
  final ClassDetails initialDetails; // Menerima data awal dari halaman sebelumnya

  const DetailKelasPage({super.key, required this.initialDetails});

  @override
  State<DetailKelasPage> createState() => _DetailKelasPageState();
}

class _DetailKelasPageState extends State<DetailKelasPage> {
  // Controller untuk setiap TextField yang tidak akan diedit
  late TextEditingController _programStudiController;
  late TextEditingController _mataKuliahController;
  late TextEditingController _kurikulumController;
  late TextEditingController _kapasitasController;
  late TextEditingController _periodeController;
  late TextEditingController _namaKelasController;
  late TextEditingController _sistemKuliahController;

  // Controllers untuk field yang bisa diedit
  late TextEditingController _sesiController;
  late TextEditingController _metodeController;
  late TextEditingController _tanggalJadwalController;
  late TextEditingController _ruangKuliahController;
  late TextEditingController _waktuSelesaiController;
  late TextEditingController _keteranganRuangKuliahController;
  late TextEditingController _urlKuliahOnlineController;

  // Variabel untuk menyimpan pilihan dropdown
  String? _selectedJenisPertemuan;
  final List<String> _jenisPertemuanOptions = ['UAS', 'UTS', 'Materi', 'Praktek'];

  String? _selectedStatus;
  final List<String> _statusOptions = ['Offline', 'Online'];

  bool _isEditing = false; // State untuk mengontrol mode edit

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Kunci untuk mengontrol Scaffold

  @override
  void initState() {
    super.initState();
    // Inisialisasi locale untuk DateFormat
    initializeDateFormatting('id_ID', null);

    // Inisialisasi controllers dengan data dari initialDetails
    _programStudiController = TextEditingController(text: widget.initialDetails.programStudi);
    _mataKuliahController = TextEditingController(text: widget.initialDetails.mataKuliah);
    _kurikulumController = TextEditingController(text: widget.initialDetails.kurikulum);
    _kapasitasController = TextEditingController(text: widget.initialDetails.kapasitas);
    _periodeController = TextEditingController(text: widget.initialDetails.periode);
    _namaKelasController = TextEditingController(text: widget.initialDetails.namaKelas);
    _sistemKuliahController = TextEditingController(text: widget.initialDetails.sistemKuliah);

    _sesiController = TextEditingController(text: widget.initialDetails.sesi);
    _metodeController = TextEditingController(text: widget.initialDetails.metode);
    _tanggalJadwalController = TextEditingController(text: widget.initialDetails.tanggalJadwal);
    _ruangKuliahController = TextEditingController(text: widget.initialDetails.ruangKuliah);
    _waktuSelesaiController = TextEditingController(text: widget.initialDetails.waktuSelesai);
    _keteranganRuangKuliahController = TextEditingController(text: widget.initialDetails.keteranganRuangKuliah);
    _urlKuliahOnlineController = TextEditingController(text: widget.initialDetails.urlKuliahOnline);

    _selectedJenisPertemuan = widget.initialDetails.jenisPertemuan;
    _selectedStatus = widget.initialDetails.status;

    _setEditingMode(false); // Default: tidak dalam mode edit
  }

  // Fungsi untuk mengaktifkan/menonaktifkan mode edit
  void _setEditingMode(bool editing) {
    setState(() {
      _isEditing = editing;
      // Mengatur ulang selection tidak lagi diperlukan untuk readOnly
    });
  }

  // Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return; // Hanya bisa diakses saat mode edit
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalJadwalController.text.isNotEmpty
          ? DateFormat('dd MMMM yyyy', 'id_ID').parse(_tanggalJadwalController.text)
          : DateTime.now(), // Menggunakan tanggal yang ada atau tanggal saat ini
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9FBADE), // Warna header kalender
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Color(0xFF37474F), // Warna teks di kalender
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FBADE), // Warna tombol cancel/ok
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalJadwalController.text = DateFormat('dd MMMM yyyy', 'id_ID').format(picked); // Format yang benar
      });
    }
  }

  // Fungsi untuk menampilkan Time Picker
  Future<void> _selectTime(BuildContext context) async {
    if (!_isEditing) return; // Hanya bisa diakses saat mode edit
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _waktuSelesaiController.text.isNotEmpty
          ? TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_waktuSelesaiController.text))
          : TimeOfDay.now(), // Menggunakan waktu yang ada atau waktu saat ini
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9FBADE), // Warna header time picker
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Color(0xFF37474F), // Warna angka di time picker
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FBADE), // Warna tombol cancel/ok
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _waktuSelesaiController.text = picked.format(context); // Format waktu
      });
    }
  }

  // Fungsi untuk reset semua field ke nilai awal (initialDetails)
  void _resetFields() {
    setState(() {
      _sesiController.text = widget.initialDetails.sesi;
      _metodeController.text = widget.initialDetails.metode;
      _tanggalJadwalController.text = widget.initialDetails.tanggalJadwal;
      _ruangKuliahController.text = widget.initialDetails.ruangKuliah;
      _waktuSelesaiController.text = widget.initialDetails.waktuSelesai;
      _keteranganRuangKuliahController.text = widget.initialDetails.keteranganRuangKuliah;
      _selectedJenisPertemuan = widget.initialDetails.jenisPertemuan;
      _urlKuliahOnlineController.text = widget.initialDetails.urlKuliahOnline;
      _selectedStatus = widget.initialDetails.status;

      _setEditingMode(false); // Kembali ke mode non-edit setelah reset
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir telah direset ke nilai awal.')),
    );
  }

  @override
  void dispose() {
    // Dispose controllers yang dibuat di sini
    _programStudiController.dispose();
    _mataKuliahController.dispose();
    _kurikulumController.dispose();
    _kapasitasController.dispose();
    _periodeController.dispose();
    _namaKelasController.dispose();
    _sistemKuliahController.dispose();

    _sesiController.dispose();
    _metodeController.dispose();
    _tanggalJadwalController.dispose();
    _ruangKuliahController.dispose();
    _waktuSelesaiController.dispose();
    _keteranganRuangKuliahController.dispose();
    _urlKuliahOnlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Tetapkan kunci scaffold
      backgroundColor: Colors.grey[50], // Latar belakang yang lebih lembut
      appBar: AppBar(
        title: const Text(
          'Detail Kelas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF90CAF9), // Warna AppBar yang serasi
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
        actions: [
          // Tambahkan aksi untuk membuka drawer
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Membuka EndDrawer
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.menu, color: Colors.white, size: 24), // Ikon menu di kanan
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        // Menambahkan Drawer di sisi kanan (endDrawer)
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF9FBADE), // Warna header drawer
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    // Avatar profil
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey[700]), // Ikon default
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jamilatul Azkia Putri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Dosen',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Color(0xFF37474F)), // Ikon Jadwal Perkuliahan
              title: const Text('Jadwal Perkuliahan', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JadwalPerkuliahanPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Color(0xFF37474F)), // Ikon Peserta Kelas
              title: const Text('Peserta Kelas', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PesertaKelasPage()), // Navigasi ke PesertaKelasPage
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Color(0xFF37474F)), // Ikon Presensi Kelas
              title: const Text('Presensi Kelas', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PresensiKelasPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade, color: Color(0xFF37474F)), // Ikon Nilai Perkuliahan
              title: const Text('Nilai Perkuliahan', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NilaiPerkuliahanPage()),
                );
              },
            ),
            // Anda bisa menambahkan item lain di sini
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian informasi dasar kelas (Card atas)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Program Studi', _programStudiController),
                    _buildInfoRow('Mata Kuliah', _mataKuliahController),
                    _buildInfoRow('Kurikulum', _kurikulumController),
                    _buildInfoRow('Kapasitas', _kapasitasController),
                    _buildInfoRow('Periode', _periodeController),
                    _buildInfoRow('Nama Kelas', _namaKelasController),
                    _buildInfoRow('Sistem Kuliah', _sistemKuliahController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Detail Jadwal', // Mengubah judul agar lebih sesuai
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF37474F)),
            ),
            const SizedBox(height: 15),

            // Bagian detail kelas (input fields)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildTextFieldRow('Sesi', _sesiController),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Metode', _metodeController),
                    const SizedBox(height: 15),
                    // Menggunakan onTap untuk Tanggal Jadwal
                    _buildTextFieldRow('Tanggal Jadwal', _tanggalJadwalController,
                        onTap: () => _selectDate(context), suffixIcon: Icons.calendar_today),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Ruang Kuliah', _ruangKuliahController),
                    const SizedBox(height: 15),
                    // Menggunakan onTap untuk Waktu Selesai
                    _buildTextFieldRow('Waktu Selesai', _waktuSelesaiController,
                        onTap: () => _selectTime(context), suffixIcon: Icons.access_time),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Keterangan Ruang Kuliah', _keteranganRuangKuliahController),
                    const SizedBox(height: 15),
                    _buildDropdownField('Jenis Pertemuan', _selectedJenisPertemuan, _jenisPertemuanOptions,
                        (String? newValue) {
                      setState(() {
                        _selectedJenisPertemuan = newValue;
                      });
                    }),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('URL Kuliah Online', _urlKuliahOnlineController),
                    const SizedBox(height: 15),
                    _buildDropdownField('Status', _selectedStatus, _statusOptions, (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol-tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isEditing
                        ? () {
                            // Buat objek ClassDetails baru dengan data saat ini
                            final updatedDetails = ClassDetails(
                              programStudi: _programStudiController.text,
                              mataKuliah: _mataKuliahController.text,
                              kurikulum: _kurikulumController.text,
                              kapasitas: _kapasitasController.text,
                              periode: _periodeController.text,
                              namaKelas: _namaKelasController.text,
                              sistemKuliah: _sistemKuliahController.text,
                              sesi: _sesiController.text,
                              metode: _metodeController.text,
                              tanggalJadwal: _tanggalJadwalController.text,
                              ruangKuliah: _ruangKuliahController.text,
                              waktuSelesai: _waktuSelesaiController.text,
                              keteranganRuangKuliah: _keteranganRuangKuliahController.text,
                              jenisPertemuan: _selectedJenisPertemuan,
                              urlKuliahOnline: _urlKuliahOnlineController.text,
                              status: _selectedStatus,
                            );
                            // Kirim data kembali ke halaman sebelumnya (MengajarHariIniPage)
                            Navigator.pop(context, updatedDetails);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Perubahan disimpan!')),
                            );
                            _setEditingMode(false);
                          }
                        : null, // Nonaktifkan jika tidak dalam mode edit
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9FBADE), // Warna biru konsisten
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: _isEditing ? 2 : 0, // Shadow hanya saat aktif
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        // Jika sedang dalam mode edit, tombol ini akan menjadi "Batal Edit"
                        _resetFields(); // Reset kembali ke nilai awal saat menekan 'Batal Edit'
                      }
                      _setEditingMode(!_isEditing); // Toggle mode edit
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Warna Edit
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    child: Text(_isEditing ? 'Batal Edit' : 'Edit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _resetFields(); // Reset field
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Warna Reset
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk baris informasi yang tidak bisa diedit
  Widget _buildInfoRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar tetap untuk label
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              controller.text,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk TextField dengan onTap opsional dan suffixIcon
  Widget _buildTextFieldRow(String hint, TextEditingController controller,
      {VoidCallback? onTap, IconData? suffixIcon}) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: !_isEditing && onTap != null, // Hanya serap jika tidak edit dan ada onTap
        child: TextField(
          controller: controller,
          readOnly: !_isEditing || onTap != null, // TextField read-only jika tidak edit ATAU ada onTap
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: _isEditing ? Colors.black54 : Colors.grey[700]),
            filled: true,
            fillColor: _isEditing ? Colors.blue.withOpacity(0.05) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _isEditing ? const Color(0xFF9FBADE) : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _isEditing ? const Color(0xFF9FBADE) : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF9FBADE),
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
            suffixIcon: suffixIcon != null && _isEditing // Tampilkan ikon hanya jika ada dan dalam mode edit
                ? Icon(suffixIcon, color: const Color(0xFF9FBADE))
                : null,
          ),
          style: TextStyle(color: _isEditing ? Colors.black87 : Colors.grey[800]),
        ),
      ),
    );
  }

  // Widget pembantu untuk Dropdown
  Widget _buildDropdownField(
      String hint, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _isEditing ? Colors.black54 : Colors.grey[700]),
        filled: true,
        fillColor: _isEditing ? Colors.blue.withOpacity(0.05) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _isEditing ? const Color(0xFF9FBADE) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _isEditing ? const Color(0xFF9FBADE) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF9FBADE),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      ),
      isEmpty: selectedValue == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: Icon(Icons.arrow_drop_down, color: _isEditing ? const Color(0xFF9FBADE) : Colors.grey),
          isExpanded: true,
          onChanged: _isEditing ? onChanged : null, // Hanya aktif jika dalam mode edit
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          style: TextStyle(color: _isEditing ? Colors.black87 : Colors.grey[800], fontSize: 16),
        ),
      ),
    );
  }
}