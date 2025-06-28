import 'package:flutter/material.dart';

class PresensiKelasListPage extends StatelessWidget {
  const PresensiKelasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Presensi Kelas'),
        backgroundColor: Theme.of(context).primaryColor, // Example color
        foregroundColor: Colors.white, // Text color for AppBar
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman daftar Presensi Kelas.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}