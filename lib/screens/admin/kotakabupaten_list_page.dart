import 'package:flutter/material.dart';

class KotaKabupatenListPage extends StatelessWidget {
  const KotaKabupatenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kota/Kabupaten'),
        backgroundColor: Theme.of(context).primaryColor, // Example color
        foregroundColor: Colors.white, // Text color for AppBar
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman daftar Kota/Kabupaten.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}