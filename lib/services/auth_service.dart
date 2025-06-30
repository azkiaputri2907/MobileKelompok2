import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://ti054e01.agussbn.my.id/api';
  static const String _origin = 'https://ti054e02.agussbn.my.id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login API - Kirim email dan password ke backend
  /// Jika berhasil, simpan token dan user ke storage, lalu return role user
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Origin': _origin,
          'X-Platform': 'mobile',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Simpan token & user
        await _storage.write(key: 'token', value: data['token']);
        await _storage.write(key: 'user', value: json.encode(data['user']));

        final role = data['user']?['role'];
        if (role != null && (role == 'Dosen' || role == 'Admin Pegawai')) {
          return role.toString(); // dikembalikan ke UI untuk diarahkan ke dashboard
        } else {
          print('Login berhasil tapi role tidak dikenali: $role');
          return 'unknown'; // role tidak valid → UI bisa handle ini
        }
      } else {
        print('Login gagal dengan status: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Terjadi error saat login: $e');
      return null;
    }
  }

  /// Ambil user yang tersimpan lokal dari secure storage
  Future<Map<String, dynamic>?> getStoredUserData() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson == null) return null;
    return json.decode(userJson) as Map<String, dynamic>;
  }

  /// Ambil user dari API endpoint /data-user dengan token Bearer
  Future<Map<String, dynamic>?> getUserData() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/data-user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Gagal mengambil data user: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error saat ambil user data: $e');
      return null;
    }
  }

  /// Logout dari backend dan hapus semua data di secure storage
  Future<void> logout() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print('Error saat logout: $e');
      }
    }

    // Tetap hapus token dan user walau logout gagal
    await _storage.deleteAll();
  }

  /// Ambil token yang tersimpan dari secure storage
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
