import 'package:flutter/material.dart';

class PresensiKelasPage extends StatefulWidget {
  const PresensiKelasPage({super.key, required int idKelasMk, required String namaMataKuliah, required String namaKelas, required String tokenDosen});

  @override
  State<PresensiKelasPage> createState() => _PresensiKelasPageState();
}

class _PresensiKelasPageState extends State<PresensiKelasPage> {
  // Dummy data untuk peserta kelas dengan status presensi
  final List<Map<String, String>> _pesertaList = [
    {'nama': 'Ahmad Budi Santoso', 'nim': '2022001', 'presensi': 'H'},
    {'nama': 'Siti Aminah', 'nim': '2022002', 'presensi': 'S'},
    {'nama': 'Dwi Cahya Putri', 'nim': '2022003', 'presensi': 'I'},
    {'nama': 'Bayu Pratama', 'nim': '2022004', 'presensi': 'H'},
    {'nama': 'Citra Dewi', 'nim': '2022005', 'presensi': 'A'},
    {'nama': 'Fajar Nugraha', 'nim': '2022006', 'presensi': 'H'},
    {'nama': 'Galih Prakoso', 'nim': '2022007', 'presensi': 'H'},
    {'nama': 'Hana Lestari', 'nim': '2022008', 'presensi': 'H'},
    {'nama': 'Irfan Maulana', 'nim': '2022009', 'presensi': 'H'},
    {'nama': 'Juwita Sari', 'nim': '2022010', 'presensi': 'H'},
  ];

  // State untuk menyimpan daftar peserta yang bisa berubah
  late List<Map<String, String>> _currentPesertaList;

  @override
  void initState() {
    super.initState();
    // Salin data dummy ke current list agar bisa diubah
    _currentPesertaList = List.from(_pesertaList);
  }

  // Fungsi untuk mengubah status presensi seorang peserta
  void _setPresensiStatus(int index, String status) {
    setState(() {
      _currentPesertaList[index]['presensi'] = status;
    });
  }

  // Fungsi untuk mereset semua presensi menjadi kosong
  void _resetPresensi() {
    setState(() {
      for (var peserta in _currentPesertaList) {
        peserta['presensi'] = ''; // Mengubah status menjadi kosong
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Silahkan presensi kembali')),
    );
  }

  // Fungsi untuk menandai semua peserta sebagai 'H' (Hadir)
  void _tandaiHadirSemua() {
    setState(() {
      for (var peserta in _currentPesertaList) {
        peserta['presensi'] = 'H';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua peserta hadir')),
    );
  }

  // Fungsi untuk mendapatkan warna berdasarkan status presensi
  Color _getStatusColor(String status) {
    switch (status) {
      case 'H':
        return Colors.green;
      case 'S':
        return Colors.orange;
      case 'I':
        return Colors.blue;
      case 'A':
        return Colors.red;
      case '': // Jika status kosong, kembalikan warna netral
        return Colors.grey[200]!;
      default:
        return Colors.grey;
    }
  }

  // Fungsi untuk mendapatkan warna teks berdasarkan status presensi
  Color _getForegroundColor(String status, bool isSelected) {
    if (isSelected) {
      return Colors.white; // Teks putih jika tombol terpilih
    }
    // Jika tidak terpilih, gunakan warna teks yang lebih gelap atau sesuai dengan warna abu-abu tombol
    return Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang yang lebih lembut
      appBar: AppBar(
        title: const Text(
          'Presensi Kelas',
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
            // Informasi Dasar Kelas
            Padding(
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
                      _buildInfoRow('Program Studi', 'D3 - Teknik Informatika'),
                      _buildInfoRow('Mata Kuliah', 'Administrasi Database'),
                      _buildInfoRow('Kurikulum', '2020'),
                      _buildInfoRow('Kapasitas', '30'),
                      _buildInfoRow('Periode', '2025 Ganjil'),
                      _buildInfoRow('Nama Kelas', '4E AXIOO'),
                      _buildInfoRow('Sistem Kuliah', 'Reguler'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Tombol Reset dan Tandai Hadir Semua
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetPresensi,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Reset Presensi', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _tandaiHadirSemua,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text('Tandai Hadir Semua', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90EE90), // Warna hijau terang
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Header daftar (Nama, NIM, Presensi)
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
                        flex: 3,
                        child: Text(
                          'Presensi',
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
            // Tambahkan SizedBox di sini untuk memastikan ada jarak setelah header
            const SizedBox(height: 12.0),

            // Daftar peserta dengan status presensi
            // Tidak lagi menggunakan Expanded, tetapi shrinkWrap dan NeverScrollableScrollPhysics
            ListView.builder(
              shrinkWrap: true, // Penting agar ListView menyesuaikan tingginya dengan konten
              physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scrolling internal ListView
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _currentPesertaList.length,
              itemBuilder: (context, index) {
                final peserta = _currentPesertaList[index];
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                peserta['nama']!,
                                style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
                              ),
                              Text(
                                peserta['nim']!,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5, // Disesuaikan untuk menampung 4 tombol
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildPresensiButton(index, 'H', 'H', peserta['presensi'] == 'H'),
                              _buildPresensiButton(index, 'S', 'S', peserta['presensi'] == 'S'),
                              _buildPresensiButton(index, 'I', 'I', peserta['presensi'] == 'I'),
                              _buildPresensiButton(index, 'A', 'A', peserta['presensi'] == 'A'),
                            ],
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

  // Widget pembantu untuk baris informasi dasar kelas
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Lebar tetap untuk label
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
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk tombol presensi (H, S, I, A)
  Widget _buildPresensiButton(int index, String label, String status, bool isSelected) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ElevatedButton(
          onPressed: () => _setPresensiStatus(index, status),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? _getStatusColor(status) : Colors.grey[200],
            foregroundColor: _getForegroundColor(status, isSelected), // Menggunakan fungsi baru untuk warna teks
            minimumSize: const Size(40, 40), // Menjadikan ukuran minimal persegi
            padding: EdgeInsets.zero, // Hapus padding default
            shape: const CircleBorder(), // Mengubah bentuk menjadi lingkaran
            elevation: isSelected ? 2 : 0,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}