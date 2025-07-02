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
// ClassDetails model
class ClassDetails {
  final int id;
  final int idProdi;
  final String nama; // nama mata kuliah
  final String namaKelas;
  final double sks;
  final int semester;

  ClassDetails({
    required this.id,
    required this.idProdi,
    required this.nama,
    required this.namaKelas,
    required this.sks,
    required this.semester,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      id: json['id'] as int,
      idProdi: json['id_prodi'] as int,
      nama: json['nama'] as String,
      namaKelas: json['nama_kelas'] ?? '',
      sks: (json['sks'] as num).toDouble(),
      semester: json['semester'] as int,
    );
  }
}

class DetailKelasPage extends StatefulWidget {
  final ClassDetails initialDetails;

  const DetailKelasPage({super.key, required this.initialDetails, required kelasId, required namaKelas, required namaMatkul, required ruangan, required String waktu, required int jadwalId, required String userName});

  @override
  State<DetailKelasPage> createState() => _DetailKelasPageState();
}

class _DetailKelasPageState extends State<DetailKelasPage> {
  late TextEditingController _mataKuliahController;
  late TextEditingController _namaKelasController;
  late TextEditingController _sksController;
  late TextEditingController _semesterController;

  @override
  void initState() {
    super.initState();
    _mataKuliahController = TextEditingController(text: widget.initialDetails.nama);
    _namaKelasController = TextEditingController(text: widget.initialDetails.namaKelas);
    _sksController = TextEditingController(text: widget.initialDetails.sks.toString());
    _semesterController = TextEditingController(text: widget.initialDetails.semester.toString());
  }

  @override
  void dispose() {
    _mataKuliahController.dispose();
    _namaKelasController.dispose();
    _sksController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kelas'),
        centerTitle: true,
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nama Mata Kuliah', _mataKuliahController),
                const SizedBox(height: 12),
                _buildInfoRow('Nama Kelas', _namaKelasController),
                const SizedBox(height: 12),
                _buildInfoRow('SKS', _sksController),
                const SizedBox(height: 12),
                _buildInfoRow('Semester', _semesterController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper
  Widget _buildInfoRow(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F),
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            controller.text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}