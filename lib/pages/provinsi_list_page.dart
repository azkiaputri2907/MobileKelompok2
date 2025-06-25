import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/service/provinsi_service.dart';
import '../model/provinsi.dart';
import '../services/provinsi_service.dart'; // pastikan ini import yang benar
import 'provinsi_form_page.dart';

class ProvinsiListPage extends StatefulWidget {
  @override
  _ProvinsiListPageState createState() => _ProvinsiListPageState();
}

class _ProvinsiListPageState extends State<ProvinsiListPage> {
  late Future<List<Provinsi>> futureProvinsi;

  @override
  void initState() {
    super.initState();
    futureProvinsi = ProvinsiService.getAll();
  }

  void refreshData() {
    setState(() {
      futureProvinsi = ProvinsiService.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Provinsi'),
      ),
      body: FutureBuilder<List<Provinsi>>(
        future: futureProvinsi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Data provinsi kosong'));
          } else {
            final provinsiList = snapshot.data!;
            return ListView.builder(
              itemCount: provinsiList.length,
              itemBuilder: (context, index) {
                final provinsi = provinsiList[index];
                return ListTile(
                  title: Text(provinsi.namaProvinsi),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Hapus Provinsi'),
                          content: Text('Yakin ingin menghapus ${provinsi.namaProvinsi}?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
                          ],
                        ),
                      );
                      if (confirm) {
                        try {
                          await ProvinsiService.delete(provinsi.id);
                          refreshData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Provinsi berhasil dihapus')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal menghapus provinsi')),
                          );
                        }
                      }
                    },
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProvinsiFormPage(provinsi: provinsi)),
                    );
                    if (result == true) refreshData();
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProvinsiFormPage()),
          );
          if (result == true) refreshData();
        },
      ),
    );
  }
}
