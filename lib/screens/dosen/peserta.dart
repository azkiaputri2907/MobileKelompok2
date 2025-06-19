import 'package:flutter/material.dart';

class PesertaKelasPage extends StatefulWidget {
  const PesertaKelasPage({super.key});

  @override
  State<PesertaKelasPage> createState() => _PesertaKelasPageState();
}

class _PesertaKelasPageState extends State<PesertaKelasPage> {
  // Daftar dummy data peserta kelas
  final List<Map<String, String>> _pesertaList = [
    {'nama': 'Ahmad Budi Santoso', 'nim': '2022001'},
    {'nama': 'Siti Aminah', 'nim': '2022002'},
    {'nama': 'Dwi Cahya Putri', 'nim': '2022003'},
    {'nama': 'Bayu Pratama', 'nim': '2022004'},
    {'nama': 'Citra Dewi', 'nim': '2022005'},
    {'nama': 'Fajar Nugraha', 'nim': '2022006'},
    {'nama': 'Galih Prakoso', 'nim': '2022007'},
    {'nama': 'Hana Lestari', 'nim': '2022008'},
    {'nama': 'Irfan Maulana', 'nim': '2022009'},
    {'nama': 'Juwita Sari', 'nim': '2022010'},
  ];

  List<Map<String, String>> _filteredPesertaList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPesertaList = _pesertaList; // Inisialisasi dengan semua data
    _searchController.addListener(_filterPeserta); // Tambahkan listener untuk pencarian
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPeserta);
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk memfilter daftar peserta berdasarkan input pencarian
  void _filterPeserta() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPesertaList = _pesertaList.where((peserta) {
        return peserta['nama']!.toLowerCase().contains(query) ||
               peserta['nim']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Fungsi untuk menampilkan detail peserta (placeholder)
  void _showPesertaDetail(Map<String, String> peserta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail ${peserta['nama']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${peserta['nama']}'),
              Text('NIM: ${peserta['nim']}'),
              const Text('Informasi lebih lanjut bisa ditambahkan di sini.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang yang lebih lembut
      appBar: AppBar(
        title: const Text(
          'Peserta Kelas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF90CAF9), // Warna AppBar yang serasi
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
      ),
      body: SingleChildScrollView( // Mengubah seluruh body menjadi scrollable
        child: Column(
          children: [
            // Bar pencarian
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Nama / NIM Peserta',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9FBADE)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9FBADE), width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
                ),
                style: const TextStyle(color: Color(0xFF37474F)),
              ),
            ),
            
            // Header daftar (Nama, NIM, Detail)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: const Color(0xFF9FBADE), // Warna header yang menarik
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'NIM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Detail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0), // Tambahkan SizedBox untuk jarak setelah header

            // Daftar peserta
            ListView.builder(
              shrinkWrap: true, // Penting agar ListView menyesuaikan tingginya dengan konten
              physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scrolling internal ListView
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredPesertaList.length,
              itemBuilder: (context, index) {
                final peserta = _filteredPesertaList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            peserta['nama']!,
                            style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            peserta['nim']!,
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () => _showPesertaDetail(peserta),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9FBADE), // Warna tombol detail
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 1,
                              ),
                              child: const Text(
                                'Lihat Detail',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
