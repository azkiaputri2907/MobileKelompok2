import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TanggunganPage extends StatefulWidget {
  final String userName; // Asumsi userName bisa diubah menjadi ID Dosen yang sebenarnya

  const TanggunganPage({super.key, required this.userName, required int dosenId});

  @override
  State<TanggunganPage> createState() => _TanggunganPageState();
}

class _TanggunganPageState extends State<TanggunganPage> {
  List<dynamic> _tanggunganList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Ganti dengan token asli dan cara mendapatkan ID dosen yang sebenarnya
  final String _dosenToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';
  // Endpoint API untuk jadwal tanggungan (belum selesai)
  final String _apiUrl = 'https://ti054e01.agussbn.my.id/api/jadwal'; // Asumsi API ini bisa difilter

  @override
  void initState() {
    super.initState();
    _fetchTanggungan();
  }

  Future<void> _fetchTanggungan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Di sini Anda perlu cara untuk mendapatkan ID Dosen yang login.
    // Untuk tujuan demo, kita akan gunakan ID 2.
    int dummyDosenId = 2; // Ganti dengan ID dosen yang sesuai dari sesi login

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?id_dosen=$dummyDosenId&status=belum_selesai'), // Filter berdasarkan ID dosen dan status
        headers: {
          'Authorization': 'Bearer $_dosenToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tanggunganList = data['data']; // Asumsi API mengembalikan {'data': [...]}
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = 'Gagal memuat tanggungan: ${errorData['message'] ?? 'Status Code: ${response.statusCode}'}';
        });
        debugPrint('Error response (Tanggungan): ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error koneksi: $e';
      });
      debugPrint('Exception in _fetchTanggungan: $e');
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
        title: const Text('Tanggungan Anda'),
        backgroundColor: const Color(0xFF191970),
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
                          onPressed: _fetchTanggungan,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _tanggunganList.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada tanggungan untuk ${widget.userName}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _tanggunganList.length,
                      itemBuilder: (context, index) {
                        final jadwal = _tanggunganList[index];
                        DateTime? tanggalJadwal;
                        try {
                          tanggalJadwal = DateTime.parse(jadwal['tanggal_jadwal']);
                        } catch (e) {
                          tanggalJadwal = null;
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
                                    color: Colors.redAccent, // Warna untuk tanggungan
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
                              ],
                            ),
                          ),
                        );
                      },
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