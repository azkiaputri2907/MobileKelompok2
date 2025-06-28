import 'package:flutter/material.dart';

class PegawaiListPage extends StatelessWidget {
  const PegawaiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pegawai'),
        backgroundColor: Theme.of(context).primaryColor, // Example color
        foregroundColor: Colors.white, // Text color for AppBar
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman daftar Pegawai.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}