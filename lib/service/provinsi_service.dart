import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/provinsi.dart';

class ProvinsiService {
  static const String baseUrl = 'https://ti054e02.agussbn.my.id/api/provinsi'; // Ganti sesuai endpoint API kamu

  static Future<List<Provinsi>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/provinsi'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Provinsi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data provinsi');
    }
  }

  static Future<void> create(String namaProvinsi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/provinsi'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama_provinsi': namaProvinsi}),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan provinsi');
    }
  }

  static Future<void> update(int id, String namaProvinsi) async {
    final response = await http.put(
      Uri.parse('$baseUrl/provinsi/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama_provinsi': namaProvinsi}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate provinsi');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/provinsi/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus provinsi');
    }
  }
}
