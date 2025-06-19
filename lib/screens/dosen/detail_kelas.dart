import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk DateFormat
import 'package:mobile_kelompok2/screens/dosen/detail_kelas.dart'; // Import ClassDetails (penting untuk data persisten)
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart';
import 'package:mobile_kelompok2/screens/dosen/peserta.dart'; // Import halaman Peserta Kelas (sesuai permintaan)
import 'package:mobile_kelompok2/screens/dosen/presensi.dart'; // Import halaman Peserta Kelas (sesuai permintaan)
import 'package:mobile_kelompok2/screens/dosen/dashboard.dart'; // Import ClassDetails (penting untuk data persisten)


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

// PesertaKelasPage sudah diimpor dari file peserta.dart, jadi tidak perlu didefinisikan ulang di sini.

// class PresensiKelasPage extends StatelessWidget {
//   const PresensiKelasPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Presensi Kelas')),
//       body: const Center(child: Text('Konten Presensi Kelas')),
//     );
//   }
// }

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
  final TextEditingController _programStudiController = TextEditingController(text: 'D3 - Teknik Informatika');
  final TextEditingController _mataKuliahController = TextEditingController(text: 'Administrasi Database');
  final TextEditingController _kurikulumController = TextEditingController(text: '2020');
  final TextEditingController _kapasitasController = TextEditingController(text: '30');
  final TextEditingController _periodeController = TextEditingController(text: '2025 Ganjil');
  final TextEditingController _namaKelasController = TextEditingController(text: '4E AXIOO');
  final TextEditingController _sistemKuliahController = TextEditingController(text: 'Reguler');

  // Controllers untuk field yang bisa diedit (late karena diinisialisasi di initState)
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
    // Inisialisasi controllers dan dropdown dengan data dari initialDetails
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
      // Mengatur ulang selection untuk memaksa UI memperbarui mode readOnly pada TextField yang dapat diedit
      _programStudiController.selection = TextSelection.collapsed(offset: _programStudiController.text.length);
      _mataKuliahController.selection = TextSelection.collapsed(offset: _mataKuliahController.text.length);
      _kurikulumController.selection = TextSelection.collapsed(offset: _kurikulumController.text.length);
      _kapasitasController.selection = TextSelection.collapsed(offset: _kapasitasController.text.length);
      _periodeController.selection = TextSelection.collapsed(offset: _periodeController.text.length);
      _namaKelasController.selection = TextSelection.collapsed(offset: _namaKelasController.text.length);
      _sistemKuliahController.selection = TextSelection.collapsed(offset: _sistemKuliahController.text.length);

      _sesiController.selection = TextSelection.collapsed(offset: _sesiController.text.length);
      _metodeController.selection = TextSelection.collapsed(offset: _metodeController.text.length);
      _tanggalJadwalController.selection = TextSelection.collapsed(offset: _tanggalJadwalController.text.length);
      _ruangKuliahController.selection = TextSelection.collapsed(offset: _ruangKuliahController.text.length);
      _waktuSelesaiController.selection = TextSelection.collapsed(offset: _waktuSelesaiController.text.length);
      _keteranganRuangKuliahController.selection = TextSelection.collapsed(offset: _keteranganRuangKuliahController.text.length);
      _urlKuliahOnlineController.selection = TextSelection.collapsed(offset: _urlKuliahOnlineController.text.length);
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
        actions: [ // Tambahkan aksi untuk membuka drawer
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
      endDrawer: Drawer( // Menambahkan Drawer di sisi kanan (endDrawer)
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
                  CircleAvatar( // Avatar profil
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
                    _buildTextFieldRow('Tanggal Jadwal', _tanggalJadwalController, onTap: () => _selectDate(context), suffixIcon: Icons.calendar_today),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Ruang Kuliah', _ruangKuliahController),
                    const SizedBox(height: 15),
                    // Menggunakan onTap untuk Waktu Selesai
                    _buildTextFieldRow('Waktu Selesai', _waktuSelesaiController, onTap: () => _selectTime(context), suffixIcon: Icons.access_time),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Keterangan Ruang Kuliah', _keteranganRuangKuliahController),
                    const SizedBox(height: 15),
                    _buildDropdownField('Jenis Pertemuan', _selectedJenisPertemuan, _jenisPertemuanOptions, (String? newValue) {
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
                      _setEditingMode(!_isEditing); // Toggle mode edit
                      if (!_isEditing) { // Jika keluar dari mode edit (yaitu menekan 'Batal Edit')
                         _resetFields(); // Reset kembali ke nilai awal saat masuk halaman
                      }
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
  Widget _buildTextFieldRow(String hint, TextEditingController controller, {VoidCallback? onTap, IconData? suffixIcon}) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap != null,
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
  Widget _buildDropdownField(String hint, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
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
