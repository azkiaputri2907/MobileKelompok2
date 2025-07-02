// lib/screens/pegawai/pegawai_list_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Untuk menghasilkan ID unik

// Employee Model
class Pegawai {
  final String id;
  String nama;
  String posisi;
  String email;

  Pegawai({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.email,
  });

  // Constructor for copy/update purposes
  Pegawai copyWith({String? id, String? nama, String? posisi, String? email}) {
    return Pegawai(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      posisi: posisi ?? this.posisi,
      email: email ?? this.email,
    );
  }
}

class PegawaiListPage extends StatefulWidget {
  const PegawaiListPage({super.key});

  @override
  State<PegawaiListPage> createState() => _PegawaiListPageState();
}

class _PegawaiListPageState extends State<PegawaiListPage> {
  final List<Pegawai> _pegawaiList = []; // In-memory list of employees
  final Uuid _uuid = const Uuid(); // Untuk menghasilkan ID unik

  @override
  void initState() {
    super.initState();
    // Tambahkan beberapa data dummy awal untuk demonstrasi
    _pegawaiList.add(Pegawai(
      id: _uuid.v4(),
      nama: 'Budi Santoso',
      posisi: 'Manajer Proyek',
      email: 'budi.s@example.com',
    ));
    _pegawaiList.add(Pegawai(
      id: _uuid.v4(),
      nama: 'Siti Aminah',
      posisi: 'Analis Data',
      email: 'siti.a@example.com',
    ));
    _pegawaiList.add(Pegawai(
      id: _uuid.v4(),
      nama: 'Joko Susilo',
      posisi: 'Pengembang Backend',
      email: 'joko.s@example.com',
    ));
  }

  // Menampilkan formulir tambah/edit sebagai dialog
  void _showAddEditDialog({Pegawai? pegawaiToEdit}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaController = TextEditingController(text: pegawaiToEdit?.nama);
    final TextEditingController posisiController = TextEditingController(text: pegawaiToEdit?.posisi);
    final TextEditingController emailController = TextEditingController(text: pegawaiToEdit?.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pegawaiToEdit == null ? 'Tambah Pegawai Baru' : 'Edit Pegawai'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView( // Agar keyboard tidak menutupi input
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pegawai',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pegawai tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: posisiController,
                    decoration: InputDecoration(
                      labelText: 'Posisi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Posisi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Masukkan email yang valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(pegawaiToEdit == null ? 'Tambah' : 'Simpan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (pegawaiToEdit == null) {
                      // Add new pegawai
                      _pegawaiList.add(
                        Pegawai(
                          id: _uuid.v4(),
                          nama: namaController.text,
                          posisi: posisiController.text,
                          email: emailController.text,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pegawai berhasil ditambahkan!')),
                      );
                    } else {
                      // Edit existing pegawai
                      final index = _pegawaiList.indexWhere((p) => p.id == pegawaiToEdit.id);
                      if (index != -1) {
                        _pegawaiList[index] = pegawaiToEdit.copyWith(
                          nama: namaController.text,
                          posisi: posisiController.text,
                          email: emailController.text,
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pegawai berhasil diperbarui!')),
                      );
                    }
                  });
                  Navigator.of(context).pop(); // Tutup dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus pegawai
  void _deletePegawai(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus pegawai ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _pegawaiList.removeWhere((p) => p.id == id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pegawai berhasil dihapus!')),
                );
                Navigator.of(context).pop();
              },
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
        title: const Text('Daftar Pegawai'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _pegawaiList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada pegawai yang terdaftar.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _pegawaiList.length,
              itemBuilder: (context, index) {
                final pegawai = _pegawaiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      pegawai.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF191970), // Dark blue
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          pegawai.posisi,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          pegawai.email,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(pegawaiToEdit: pegawai),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePegawai(pegawai.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(), // Panggil dialog untuk menambah
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}