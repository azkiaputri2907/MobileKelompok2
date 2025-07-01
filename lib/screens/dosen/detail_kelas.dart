import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import untuk DateFormat
import 'package:intl/date_symbol_data_local.dart'; // Import untuk inisialisasi lokal

// Import halaman-halaman lain yang mungkin dibutuhkan oleh Drawer
import 'package:mobile_kelompok2/screens/dosen/jadwal_dosen.dart';
import 'package:mobile_kelompok2/screens/dosen/peserta.dart';
import 'package:mobile_kelompok2/screens/dosen/presensi.dart';

// Placeholder pages for Drawer navigation.
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

// Kelas model data untuk Detail Kelas
class ClassDetails {
  final int id; // Tambahkan ID pertemuan/jadwal
  final String programStudi;
  final String mataKuliah;
  final String kurikulum; // Data ini mungkin perlu diambil dari relasi lain jika tidak langsung ada di 'pertemuan'
  final String kapasitas; // Data ini mungkin perlu diambil dari relasi lain jika tidak langsung ada di 'pertemuan'
  final String periode; // Data ini mungkin perlu diambil dari relasi lain jika tidak langsung ada di 'pertemuan'
  final String namaKelas;
  final String sistemKuliah; // Data ini mungkin perlu diambil dari relasi lain jika tidak langsung ada di 'pertemuan'

  // Fields yang bisa diedit
  final String sesi; // Asumsi ini adalah waktu mulai
  final String metode;
  final String tanggalJadwal;
  final String ruangKuliah;
  final String waktuSelesai;
  final String keteranganRuangKuliah;
  final String? jenisPertemuan;
  final String urlKuliahOnline;
  final String? status; // status_jadwal

  ClassDetails({
    required this.id,
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

  // Factory constructor untuk membuat ClassDetails dari JSON
  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      id: json['id'] as int,
      programStudi: json['kelas']?['prodi']?['nama'] ?? 'N/A', // Contoh akses nested JSON
      mataKuliah: json['mata_kuliah']?['nama'] ?? 'N/A',
      // Anda perlu menyesuaikan pengambilan data 'kurikulum', 'kapasitas', 'periode', 'sistemKuliah'
      // Jika data ini tidak langsung ada di objek 'pertemuan' dari API,
      // Anda mungkin perlu menambahkannya di backend atau mengambilnya dari API lain.
      kurikulum: 'N/A', // Placeholder, sesuaikan jika ada di API
      kapasitas: 'N/A', // Placeholder, sesuaikan jika ada di API
      periode: json['tahun_akademik']?['nama'] ?? 'N/A', // Asumsi nama periode dari tahun akademik
      namaKelas: json['kelas']?['nama_kelas'] ?? 'N/A',
      sistemKuliah: 'N/A', // Placeholder, sesuaikan jika ada di API

      sesi: json['waktu_mulai'] ?? 'N/A', // Sesi diasumsikan waktu_mulai
      metode: json['metode'] ?? 'N/A',
      tanggalJadwal: json['tanggal_jadwal'] != null
          ? DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(json['tanggal_jadwal']))
          : 'N/A',
      ruangKuliah: json['ruang_kuliah'] ?? 'N/A',
      waktuSelesai: json['waktu_selesai'] ?? 'N/A',
      keteranganRuangKuliah: json['keterangan_ruang'] ?? 'N/A',
      jenisPertemuan: json['jenis_pertemuan'],
      urlKuliahOnline: json['url_kuliah_online'] ?? 'N/A',
      status: json['status_jadwal'],
    );
  }

  // Metode copyWith untuk memudahkan update objek
  ClassDetails copyWith({
    int? id,
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
      id: id ?? this.id,
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
  late TextEditingController _sesiController; // waktu_mulai
  late TextEditingController _metodeController;
  late TextEditingController _tanggalJadwalController;
  late TextEditingController _ruangKuliahController;
  late TextEditingController _waktuSelesaiController;
  late TextEditingController _keteranganRuangKuliahController;
  late TextEditingController _urlKuliahOnlineController;

  // Variabel untuk menyimpan pilihan dropdown
  String? _selectedJenisPertemuan;
  final List<String> _jenisPertemuanOptions = ['UAS', 'UTS', 'Materi', 'Praktek'];

  String? _selectedStatus; // ini adalah status_jadwal, BUKAN metode (Offline/Online)
  final List<String> _statusOptions = ['Aktif', 'Selesai', 'Dibatalkan']; // Contoh status jadwal

  bool _isEditing = false; // State untuk mengontrol mode edit
  bool _isLoading = false; // State untuk indikator loading saat menyimpan

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Kunci untuk mengontrol Scaffold
  final String _dosenToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC'; // Token autentikasi

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    _initializeControllers(widget.initialDetails);
    _setEditingMode(false); // Default: tidak dalam mode edit
  }

  // Helper untuk menginisialisasi controller
  void _initializeControllers(ClassDetails details) {
    _programStudiController = TextEditingController(text: details.programStudi);
    _mataKuliahController = TextEditingController(text: details.mataKuliah);
    _kurikulumController = TextEditingController(text: details.kurikulum);
    _kapasitasController = TextEditingController(text: details.kapasitas);
    _periodeController = TextEditingController(text: details.periode);
    _namaKelasController = TextEditingController(text: details.namaKelas);
    _sistemKuliahController = TextEditingController(text: details.sistemKuliah);

    _sesiController = TextEditingController(text: details.sesi);
    _metodeController = TextEditingController(text: details.metode);
    _tanggalJadwalController = TextEditingController(text: details.tanggalJadwal);
    _ruangKuliahController = TextEditingController(text: details.ruangKuliah);
    _waktuSelesaiController = TextEditingController(text: details.waktuSelesai);
    _keteranganRuangKuliahController = TextEditingController(text: details.keteranganRuangKuliah);
    _urlKuliahOnlineController = TextEditingController(text: details.urlKuliahOnline);

    _selectedJenisPertemuan = details.jenisPertemuan;
    _selectedStatus = details.status;
  }

  // Fungsi untuk mengaktifkan/menonaktifkan mode edit
  void _setEditingMode(bool editing) {
    setState(() {
      _isEditing = editing;
    });
  }

  // Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalJadwalController.text.isNotEmpty && _tanggalJadwalController.text != 'N/A'
          ? DateFormat('dd MMMM yyyy', 'id_ID').parse(_tanggalJadwalController.text)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9FBADE),
              onPrimary: Colors.white,
              onSurface: Color(0xFF37474F),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FBADE),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalJadwalController.text = DateFormat('dd MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  // Fungsi untuk menampilkan Time Picker
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    if (!_isEditing) return;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.text.isNotEmpty && controller.text != 'N/A'
          ? TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(controller.text))
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9FBADE),
              onPrimary: Colors.white,
              onSurface: Color(0xFF37474F),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FBADE),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  // Fungsi untuk reset semua field ke nilai awal (initialDetails)
  void _resetFields() {
    setState(() {
      _initializeControllers(widget.initialDetails); // Inisialisasi ulang dengan data awal
      _setEditingMode(false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir telah direset ke nilai awal.')),
    );
  }

  // Fungsi untuk menyimpan perubahan ke backend
  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // Format tanggal kembali ke YYYY-MM-DD untuk backend
    String formattedTanggalJadwal;
    try {
      formattedTanggalJadwal = DateFormat('yyyy-MM-dd').format(
          DateFormat('dd MMMM yyyy', 'id_ID').parse(_tanggalJadwalController.text));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tanggal tidak valid.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> updatedData = {
      // Pastikan keys ini cocok dengan nama kolom di tabel 'presensi' atau DTO di Laravel Anda
      'waktu_mulai': _sesiController.text, // Sesi
      'metode': _metodeController.text,
      'tanggal_jadwal': formattedTanggalJadwal,
      'ruang_kuliah': _ruangKuliahController.text,
      'waktu_selesai': _waktuSelesaiController.text,
      'keterangan_ruang': _keteranganRuangKuliahController.text,
      'jenis_pertemuan': _selectedJenisPertemuan,
      'url_kuliah_online': _urlKuliahOnlineController.text,
      'status_jadwal': _selectedStatus, // Sesuaikan dengan field di DB
    };

    // Remove null values to avoid sending them if not explicitly needed by backend
    updatedData.removeWhere((key, value) => value == null || value == 'N/A' || value.isEmpty);

    // Endpoint untuk UPDATE pertemuan (Laravel PUT/PATCH)
    // Asumsi route Anda adalah /api/presensi/pertemuan/{id}
    final String apiUrl = 'https://ti054e01.agussbn.my.id/api/presensi/pertemuan/${widget.initialDetails.id}';

    try {
      final response = await http.put( // Gunakan PUT atau PATCH
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_dosenToken',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      print('Request URL (DetailKelasPage Update): $apiUrl');
      print('Request Body (DetailKelasPage Update): ${jsonEncode(updatedData)}');
      print('Response Status Code (DetailKelasPage Update): ${response.statusCode}');
      print('Response Body (DetailKelasPage Update): ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Jika API mengembalikan data pertemuan yang diperbarui, gunakan itu
        final updatedMeetingData = responseData['data'] ?? responseData;

        // Perbarui ClassDetails yang dipegang oleh widget
        final updatedClassDetails = ClassDetails.fromJson(updatedMeetingData);
        _initializeControllers(updatedClassDetails); // Perbarui controllers dengan data terbaru

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan jadwal berhasil disimpan!')),
        );
        _setEditingMode(false); // Kembali ke mode non-edit
        // Opsional: pop dan kirim data kembali ke halaman sebelumnya jika perlu refresh daftar
        // Navigator.pop(context, updatedClassDetails);
      } else {
        String errorMessage = 'Gagal menyimpan perubahan. Status Code: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
        } catch (e) {
          // Jika respons bukan JSON
          errorMessage = 'Gagal menyimpan perubahan. Status Code: ${response.statusCode}. Respon tidak valid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error koneksi atau parsing data: $e. Pastikan backend berjalan.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detail Kelas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF90CAF9),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.menu, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF9FBADE),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jamilatul Azkia Putri', // Ganti dengan nama dosen sebenarnya
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
              leading: const Icon(Icons.schedule, color: Color(0xFF37474F)),
              title: const Text('Jadwal Perkuliahan', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JadwalPerkuliahanPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Color(0xFF37474F)),
              title: const Text('Peserta Kelas', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PesertaKelasPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Color(0xFF37474F)),
              title: const Text('Presensi Kelas', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PresensiKelasPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade, color: Color(0xFF37474F)),
              title: const Text('Nilai Perkuliahan', style: TextStyle(color: Color(0xFF37474F))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NilaiPerkuliahanPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Detail Jadwal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF37474F)),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildTextFieldRow('Waktu Mulai (Sesi)', _sesiController,
                        onTap: () => _selectTime(context, _sesiController), suffixIcon: Icons.access_time),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Metode', _metodeController),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Tanggal Jadwal', _tanggalJadwalController,
                        onTap: () => _selectDate(context), suffixIcon: Icons.calendar_today),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Ruang Kuliah', _ruangKuliahController),
                    const SizedBox(height: 15),
                    _buildTextFieldRow('Waktu Selesai', _waktuSelesaiController,
                        onTap: () => _selectTime(context, _waktuSelesaiController), suffixIcon: Icons.access_time),
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
                    _buildDropdownField('Status Jadwal', _selectedStatus, _statusOptions, (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _isEditing ? _saveChanges : null, // Panggil _saveChanges
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9FBADE),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: _isEditing ? 2 : 0,
                          ),
                          child: const Text('Simpan'),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        _resetFields();
                      }
                      _setEditingMode(!_isEditing);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
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
                      _resetFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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
            width: 120,
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
        absorbing: !_isEditing && onTap != null,
        child: TextField(
          controller: controller,
          readOnly: !_isEditing || onTap != null,
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
            suffixIcon: suffixIcon != null && _isEditing
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
          onChanged: _isEditing ? onChanged : null,
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