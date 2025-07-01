import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart';

class PresensiKelasListPage extends StatefulWidget {
  const PresensiKelasListPage({super.key});

  @override
  State<PresensiKelasListPage> createState() => _PresensiKelasListPageState();
}

class _PresensiKelasListPageState extends State<PresensiKelasListPage> {
  List<dynamic> _jadwalList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Ganti dengan token asli yang kamu simpan aman
  final String _adminToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';
  // Ganti sesuai endpoint API untuk mendapatkan semua jadwal
  final String _apiUrl = 'https://ti054e01.agussbn.my.id/api/jadwal';

  @override
  void initState() {
    super.initState();
    _fetchJadwal();
  }

  Future<void> _fetchJadwal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_adminToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _jadwalList = data['data']; // Asumsi API mengembalikan {'data': [...]}
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = 'Gagal memuat jadwal: ${errorData['message'] ?? 'Status Code: ${response.statusCode}'}';
        });
        debugPrint('Error response: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error koneksi: $e';
      });
      debugPrint('Exception in _fetchJadwal: $e');
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
        title: const Text('Daftar Presensi Kelas'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 50),
                        SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchJadwal,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _jadwalList.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada jadwal kelas yang tersedia.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _jadwalList.length,
                      itemBuilder: (context, index) {
                        final jadwal = _jadwalList[index];
                        // Parsing tanggal agar bisa diformat
                        DateTime? tanggalJadwal;
                        try {
                          tanggalJadwal = DateTime.parse(jadwal['tanggal_jadwal']);
                        } catch (e) {
                          tanggalJadwal = null; // Handle invalid date format
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jadwal['judul'] ?? 'Tanpa Judul',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.book, 'Sesi', jadwal['sesi'] ?? '-'),
                                _buildInfoRow(Icons.settings, 'Metode', jadwal['metode'] ?? '-'),
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  'Tanggal',
                                  tanggalJadwal != null
                                      ? DateFormat('dd MMMM yyyy').format(tanggalJadwal)
                                      : jadwal['tanggal_jadwal'] ?? '-',
                                ),
                                _buildInfoRow(Icons.room, 'Ruang', jadwal['ruang_kuliah'] ?? '-'),
                                _buildInfoRow(Icons.access_time, 'Selesai', jadwal['waktu_selesai'] ?? '-'),
                                if (jadwal['keterangan_ruang'] != null && jadwal['keterangan_ruang'].isNotEmpty)
                                  _buildInfoRow(Icons.info_outline, 'Ket. Ruang', jadwal['keterangan_ruang']),
                                _buildInfoRow(Icons.category, 'Jenis', jadwal['jenis_pertemuan'] ?? '-'),
                                _buildInfoRow(Icons.online_prediction, 'Status', jadwal['status'] ?? '-'),
                                if (jadwal['status'] == 'Online' && jadwal['url_kuliah_online'] != null && jadwal['url_kuliah_online'].isNotEmpty)
                                  _buildInfoRow(Icons.link, 'URL Online', jadwal['url_kuliah_online']),
                                _buildInfoRow(Icons.person, 'ID Dosen', jadwal['id_dosen']?.toString() ?? '-'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ketika kembali dari BukaKelasPage, refresh daftar jadwal
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BukaKelasPage()),
          );
          if (result == true) {
            _fetchJadwal(); // Refresh data jika ada perubahan
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}