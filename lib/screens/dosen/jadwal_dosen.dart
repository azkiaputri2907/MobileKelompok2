import 'package:flutter/material.dart';

class MengajarHariIniPage extends StatefulWidget {
  const MengajarHariIniPage({super.key});

  @override
  State<MengajarHariIniPage> createState() => _MengajarHariIniPageState();
}

class _MengajarHariIniPageState extends State<MengajarHariIniPage> {
  bool _isClassEntered = false; // State untuk melacak apakah tombol "Masuk Kelas" sudah ditekan

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
        backgroundColor: const Color(0xFFC8A2C8), // Warna AppBar yang serasi
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
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
                                    });
                                  }
                                : null, // Tidak berfungsi jika belum masuk kelas
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300], // Warna abu-abu saat tidak aktif
                              foregroundColor: Colors.grey[700],
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
                                ? () {
                                    // Logika untuk tombol Detail Kelas
                                    print('Tombol Detail Kelas ditekan!');
                                    // Anda bisa menavigasi ke halaman detail kelas di sini
                                  }
                                : null, // Tidak berfungsi jika belum masuk kelas
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300], // Warna abu-abu saat tidak aktif
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0, // Tanpa shadow
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
