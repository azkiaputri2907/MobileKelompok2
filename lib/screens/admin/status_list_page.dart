import 'package:flutter/material.dart';

class StatusListPage extends StatelessWidget {
  const StatusListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Status'),
        backgroundColor: Theme.of(context).primaryColor, // Example color
        foregroundColor: Colors.white, // Text color for AppBar
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman daftar Status.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}