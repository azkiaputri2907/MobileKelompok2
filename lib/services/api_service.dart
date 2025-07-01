import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://ti054e01.agussbn.my.id/api';
  static const String _adminServiceToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';
  static const String _dosenOriginToken = 'yCwwskzFMBYEoZxLjzDVxDs2C5bI8FJdeN5CnuiLwzCuyU8Kq6dyIUNfOCOCnKp3'; // Token API Key Dosen

  // Method untuk login dosen
  static Future<Map<String, dynamic>> loginDosen(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login'); // Sesuaikan endpoint login Anda
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_dosenOriginToken', // Menggunakan token API key dosen
          'X-Admin-Service-Token': _adminServiceToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Asumsi API mengembalikan token di 'token' atau 'access_token'
        // dan data user di 'user' atau 'data'
        return {'success': true, 'token': responseData['token'], 'user': responseData['user']};
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Method untuk mendapatkan token dari penyimpanan lokal
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Method untuk menyimpan token ke penyimpanan lokal
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Method untuk menghapus token dari penyimpanan lokal (saat logout)
  static Future<void> deleteAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Helper method untuk membuat header dengan token autentikasi
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getAuthToken();
    return {
      'Accept': 'application/json',
      'X-Admin-Service-Token': _adminServiceToken,
      'Authorization': 'Bearer ${token ?? _dosenOriginToken}', // Fallback ke dosen origin token jika token user null (misal untuk request awal atau jika ada API yang memerlukan token dasar)
      'Content-Type': 'application/json',
    };
  }

  // --- API Kelas/Jadwal Dosen ---

  // Mendapatkan daftar kelas yang diampu dosen
  static Future<Map<String, dynamic>> getDosenClasses() async {
    final url = Uri.parse('$_baseUrl/dosen/kelas'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']}; // Asumsi data kelas ada di kunci 'data'
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal mengambil data kelas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Membuka kelas
  static Future<Map<String, dynamic>> openClass(String classId, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl/kelas/$classId/buka'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message'] ?? 'Kelas berhasil dibuka'};
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal membuka kelas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Mengakhiri kelas
  static Future<Map<String, dynamic>> closeClass(String classId, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl/kelas/$classId/akhiri'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message'] ?? 'Kelas berhasil diakhiri'};
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal mengakhiri kelas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Mendapatkan detail kelas
  static Future<Map<String, dynamic>> getClassDetails(String classId) async {
    final url = Uri.parse('$_baseUrl/kelas/$classId/detail'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']}; // Asumsi detail kelas ada di kunci 'data'
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal mengambil detail kelas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Mendapatkan presensi kelas
  static Future<Map<String, dynamic>> getClassPresensi(String classId) async {
    final url = Uri.parse('$_baseUrl/kelas/$classId/presensi'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']}; // Asumsi data presensi ada di kunci 'data'
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal mengambil data presensi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Mendapatkan peserta kelas
  static Future<Map<String, dynamic>> getClassParticipants(String classId) async {
    final url = Uri.parse('$_baseUrl/kelas/$classId/peserta'); // Sesuaikan endpoint Anda
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']}; // Asumsi data peserta ada di kunci 'data'
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Gagal mengambil data peserta'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}