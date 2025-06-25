import 'package:flutter/material.dart';
// import 'pegawai_list_page.dart';
// import 'status_list_page.dart';
import '../../pages/provinsi_list_page.dart';
// import 'kotakabupaten_list_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        children: [
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Kelola Pegawai'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const PegawaiListPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.verified_user),
          //   title: const Text('Kelola Status Pegawai'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const StatusListPage()),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Kelola Provinsi'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProvinsiListPage()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.location_city),
          //   title: const Text('Kelola Kota/Kabupaten'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const KotaKabupatenListPage()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
