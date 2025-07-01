import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MengajarHariIniPage extends StatefulWidget {
  final String userName; // Asumsi userName bisa diubah menjadi ID Dosen yang sebenarnya

  const MengajarHariIniPage({super.key, required this.userName});

  @override
  State<MengajarHariIniPage> createState() => _MengajarHariIniPageState();
}

class _MengajarHariIniPageState extends State<MengajarHariIniPage> {
  List<dynamic> _jadwalHariIni = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Ganti dengan token asli dan cara mendapatkan ID dosen yang sebenarnya
  final String _dosenToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';
  // Endpoint API untuk jadwal hari ini, mungkin perlu parameter id_dosen
  final String _apiUrl = 'https://ti054e01.agussbn.my.id/api/jadwal/hariini';

  @override
  void initState() {
    super.initState();
    _fetchJadwalHariIni();
  }

  Future<void> _fetchJadwalHariIni() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Di sini Anda perlu cara untuk mendapatkan ID Dosen yang login.
    // Untuk tujuan demo, kita akan gunakan ID 2 seperti contoh di dashboard admin.
    // Di aplikasi nyata, ID ini harus didapat dari sesi login.
    int dummyDosenId = 2; // Ganti dengan ID dosen yang sesuai dari sesi login

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?id_dosen=$dummyDosenId'), // Filter berdasarkan ID dosen
        headers: {
          'Authorization': 'Bearer $_dosenToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Asumsi API mengembalikan {'data': [...]}
        // Filter jadwal yang memiliki tanggal hari ini
        final List allJadwal = data['data'];
        final today = DateTime.now();
        final formattedToday = DateFormat('yyyy-MM-dd').format(today);

        final filteredJadwal = allJadwal.where((jadwal) {
          try {
            return DateFormat('yyyy-MM-dd').format(DateTime.parse(jadwal['tanggal_jadwal'])) == formattedToday;
          } catch (e) {
            return false; // Abaikan jika format tanggal tidak valid
          }
        }).toList();

        setState(() {
          _jadwalHariIni = filteredJadwal;
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = 'Gagal memuat jadwal hari ini: ${errorData['message'] ?? 'Status Code: ${response.statusCode}'}';
        });
        debugPrint('Error response (MengajarHariIni): ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error koneksi: $e';
      });
      debugPrint('Exception in _fetchJadwalHariIni: $e');
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
        title: const Text('Jadwal Mengajar Hari Ini'),
        backgroundColor: const Color(0xFF90CAF9),
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
                          onPressed: _fetchJadwalHariIni,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _jadwalHariIni.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada jadwal mengajar hari ini untuk ${widget.userName}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _jadwalHariIni.length,
                      itemBuilder: (context, index) {
                        final jadwal = _jadwalHariIni[index];
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