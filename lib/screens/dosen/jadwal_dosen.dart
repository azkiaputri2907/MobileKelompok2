import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/screens/dosen/detail_kelas.dart'; // Import halaman Detail Kelas
// Pastikan Anda mengimpor DashboardDosen jika berada di file terpisah
import 'package:mobile_kelompok2/screens/dosen/dashboarddosen.dart'; // <--- Tambahkan ini

// Model data untuk menyimpan detail kelas yang bisa diedit
class ClassDetails {
  String sesi;
  String metode;
  String tanggalJadwal;
  String ruangKuliah;
  String waktuSelesai;
  String keteranganRuangKuliah;
  String? jenisPertemuan;
  String urlKuliahOnline;
  String? status;

  ClassDetails({
    this.sesi = '',
    this.metode = '',
    this.tanggalJadwal = '',
    this.ruangKuliah = '',
    this.waktuSelesai = '',
    this.keteranganRuangKuliah = '',
    this.jenisPertemuan,
    this.urlKuliahOnline = '',
    this.status,
  });

  // Metode untuk mereset semua nilai ke default/kosong
  void reset() {
    sesi = '';
    metode = '';
    tanggalJadwal = '';
    ruangKuliah = '';
    waktuSelesai = '';
    keteranganRuangKuliah = '';
    jenisPertemuan = null;
    urlKuliahOnline = '';
    status = null;
  }
}

class MengajarHariIniPage extends StatefulWidget {
  const MengajarHariIniPage({super.key});

  @override
  State<MengajarHariIniPage> createState() => _MengajarHariIniPageState();
}

class _MengajarHariIniPageState extends State<MengajarHariIniPage> {
  bool _isClassEntered = false; // State untuk melacak apakah tombol "Masuk Kelas" sudah ditekan
  ClassDetails _currentClassDetails = ClassDetails(); // Instance data kelas yang akan disimpan

  // Fungsi untuk menampilkan dialog popup
  void _showClassOpenedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi Kelas'),
          content: const Text('Kelas sudah dibuka'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mengajar Hari Ini',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF90CAF9), // Warna AppBar yang serasi
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
        // VVVV Perubahan ada di sini VVVV
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ini akan kembali ke rute sebelumnya di stack navigasi.
            // Jika sebelumnya dari DashboardDosen, maka akan kembali ke sana.
            // Jika Anda ingin memastikan selalu kembali ke DashboardDosen()
            // bahkan jika ada rute lain di atasnya, gunakan:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardDosen()),
              (Route<dynamic> route) => false, // Menghapus semua rute di bawahnya
            );
          },
        ),
        // ^^^^ Perubahan ada di sini ^^^^
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card untuk detail mata kuliah
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'TEKNIK INFORMATIKA 4E (AXIOO)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37474F),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9FBADE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '3 SKS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '08.00 - 10.00',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.apartment, color: Colors.grey, size: 20), // Ikon gedung
                        SizedBox(width: 8),
                        Text(
                          'Gedung H',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.description, color: Colors.grey, size: 20), // Ikon deskripsi
                        SizedBox(width: 8),
                        Text(
                          'Pertemuan ke-7 Praktikum',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isClassEntered
                                ? () {
                                    // Logika untuk tombol Akhiri Kelas
                                    print('Tombol Akhiri Kelas ditekan!');
                                    setState(() {
                                      _isClassEntered = false; // Set kembali ke belum masuk kelas
                                      _currentClassDetails.reset(); // Reset semua data kelas
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Kelas telah diakhiri dan data direset.')),
                                    );
                                  }
                                : null, // Tidak berfungsi jika belum masuk kelas
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 0, 0), // Warna abu-abu saat tidak aktif
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0, // Tanpa shadow
                            ),
                            child: const Text('Akhiri Kelas'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isClassEntered
                                ? null // Tidak berfungsi jika sudah masuk kelas
                                : () {
                                    // Logika untuk tombol Masuk Kelas
                                    print('Tombol Masuk Kelas ditekan!');
                                    setState(() {
                                      _isClassEntered = true; // Set menjadi sudah masuk kelas
                                    });
                                    _showClassOpenedDialog(context); // Tampilkan popup
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isClassEntered ? Colors.grey[300] : const Color(0xFF9FBADE), // Warna biru saat aktif, abu-abu saat tidak aktif
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2, // Shadow untuk tombol aktif
                            ),
                            child: const Text('Masuk Kelas'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isClassEntered
                                ? () async {
                                    // Logika untuk tombol Detail Kelas
                                    print('Tombol Detail Kelas ditekan!');
                                    // Navigasi ke DetailKelasPage dan tunggu hasilnya
                                    final updatedDetails = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailKelasPage(initialDetails: _currentClassDetails),
                                      ),
                                    );

                                    // Perbarui state jika ada data yang dikembalikan
                                    if (updatedDetails != null && updatedDetails is ClassDetails) {
                                      setState(() {
                                        _currentClassDetails = updatedDetails;
                                      });
                                    }
                                  }
                                : null, // Tidak berfungsi jika belum masuk kelas
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isClassEntered ? const Color(0xFF9FBADE) : Colors.grey[300], // Warna biru saat aktif, abu-abu saat tidak aktif
                              foregroundColor: _isClassEntered ? Colors.white : Colors.grey[700], // Warna teks putih saat aktif, abu-abu saat tidak aktif
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: _isClassEntered ? 2 : 0, // Shadow hanya saat aktif
                            ),
                            child: const Text('Detail Kelas'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Anda bisa menambahkan item lain di halaman ini jika diperlukan
          ],
        ),
      ),
    );
  }
}