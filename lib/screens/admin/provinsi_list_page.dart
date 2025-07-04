import 'package:flutter/material.dart';

class ProvinsiListPage extends StatelessWidget {
  const ProvinsiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Provinsi'),
        backgroundColor: Theme.of(context).primaryColor, // Example color
        foregroundColor: Colors.white, // Text color for AppBar
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman daftar Provinsi.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}