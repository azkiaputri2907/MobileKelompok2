import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Hapus atau komentari import dashboarddosen.dart jika tidak digunakan lagi di file ini
// import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart';

// Hapus definisi kelas MataKuliah di sini jika Anda tidak menggunakannya lagi
// karena BukaKelasPage ini sekarang hanya untuk menambahkan mata kuliah baru,
// bukan untuk berinteraksi dengan objek MataKuliah yang sudah ada.
// Jika Anda memang memisahkannya ke models/mata_kuliah.dart, pastikan untuk mengimpornya.

class BukaKelasPage extends StatefulWidget {
  // === PENTING: Hapus parameter selectedMatkul dari konstruktor ===
  const BukaKelasPage({Key? key}) : super(key: key);

  @override
  State<BukaKelasPage> createState() => _BukaKelasPageState();
}

class _BukaKelasPageState extends State<BukaKelasPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaMatkulController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  // Ini tidak perlu jika 'nama_kelas' tidak ada di tabel matakuliah
  // Anda mungkin perlu menanganinya di backend jika ingin memisahkan
  // nama mata kuliah dan nama kelas.
  final TextEditingController _namaKelasController = TextEditingController();

  bool _isLoading = false;

  // Ganti dengan token admin yang valid dan ambil secara dinamis jika memungkinkan
  final String _adminToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';

  // Pastikan URL ini benar untuk endpoint API Anda untuk MENAMBAH MATA KULIAH
  final String _apiUrl = 'https://ti054e01.agussbn.my.id/api/matkul/buat-matkul';

  @override
  void dispose() {
    _namaMatkulController.dispose();
    _sksController.dispose();
    _semesterController.dispose();
    _namaKelasController.dispose(); // Pastikan didispose juga
    super.dispose();
  }

  // === PENTING: Hapus logika yang berhubungan dengan selectedMatkul di initState ===
  @override
  void initState() {
    super.initState();
    // Tidak ada lagi logika untuk mengisi form dari selectedMatkul
  }


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final data = {
      'nama': _namaMatkulController.text, // Nama Mata Kuliah
      'sks': _sksController.text,        // SKS
      'semester': _semesterController.text, // Semester
      'id_prodi': '1', // Anda mungkin perlu dropdown untuk memilih prodi atau sesuaikan dengan kebutuhan backend
    };

    // Jika 'nama_kelas' perlu dikirim, Anda harus memastikan API backend Anda siap menerimanya
    // dan menanganinya (misalnya menyimpannya di tabel terpisah atau mengabaikannya).
    // Untuk saat ini, saya akan mengomentari jika itu bukan bagian dari tabel 'matkul'.
    // data['nama_kelas'] = _namaKelasController.text; // Contoh jika diperlukan

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_adminToken',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('Request URL: $_apiUrl');
      print('Request Headers: ${response.request?.headers}');
      print('Request Body: ${jsonEncode(data)}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (mounted) { // Periksa mounted sebelum menggunakan context
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mata Kuliah berhasil ditambahkan!')),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) { // Periksa mounted sebelum menggunakan context
          if (response.headers['content-type']?.contains('application/json') ?? false) {
            final resBody = jsonDecode(response.body);
            final errorMsg = resBody['message'] ?? resBody['error'] ?? 'Terjadi kesalahan yang tidak diketahui dari API.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error API (${response.statusCode}): $errorMsg')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error dari server (bukan JSON): Status ${response.statusCode} - ${response.body.substring(0, Math.min(response.body.length, 150))}...'),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) { // Periksa mounted sebelum menggunakan context
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error koneksi atau parsing data: $e. Pastikan backend berjalan dan terakses.')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah Baru'),
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.white, // Agar teks judul putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaMatkulController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama Mata Kuliah harus diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _sksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SKS harus diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'SKS harus berupa angka (misal: 3.0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _semesterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Semester harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Semester harus berupa angka (misal: 1, 2, dst.)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan Mata Kuliah',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}