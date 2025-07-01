// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class BukaKelasPage extends StatefulWidget {
  const BukaKelasPage({Key? key}) : super(key: key);

  @override
  State<BukaKelasPage> createState() => _BukaKelasPageState();
}

class _BukaKelasPageState extends State<BukaKelasPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _sesiController = TextEditingController();
  final TextEditingController _metodeController = TextEditingController();
  final TextEditingController _ruangController = TextEditingController();
  final TextEditingController _waktuSelesaiController = TextEditingController();
  final TextEditingController _keteranganRuangController = TextEditingController();
  final TextEditingController _urlOnlineController = TextEditingController();

  DateTime? _tanggalJadwal;
  TimeOfDay? _waktuSelesai;

  String? _jenisPertemuan;
  String? _status;

  bool _isLoading = false;

  final List<String> jenisPertemuanList = ['UAS', 'UTS', 'Praktek', 'Materi'];
  final List<String> statusList = ['Offline', 'Online'];

  // Ganti dengan token asli yang kamu simpan aman
  final String _adminToken = 'pQuALuRdwhD9RTAi7cUYmEREDOq594ckJMSQcjWdHKfxQthH2e99lfZGzUvtiJJC';

  // Ganti sesuai endpoint API untuk simpan jadwal
  final String _apiUrl = 'https://ti054e01.agussbn.my.id/api/jadwal';

  @override
  void dispose() {
    _judulController.dispose();
    _sesiController.dispose();
    _metodeController.dispose();
    _ruangController.dispose();
    _waktuSelesaiController.dispose();
    _keteranganRuangController.dispose();
    _urlOnlineController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _tanggalJadwal ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _tanggalJadwal = newDate;
              });
            },
          ),
        );
      },
    );
  }
  Future<void> _pickWaktuSelesai() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _waktuSelesai ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _waktuSelesai = picked;
        _waktuSelesaiController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tanggalJadwal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal jadwal')),
      );
      return;
    }
    if (_jenisPertemuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis pertemuan')),
      );
      return;
    }
    if (_status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih status kelas')),
      );
      return;
    }
    if (_status == 'Online' && _urlOnlineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL Kuliah Online wajib diisi jika status Online')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      'judul': _judulController.text,
      'sesi': _sesiController.text,
      'metode': _metodeController.text,
      'tanggal_jadwal': _tanggalJadwal!.toIso8601String(),
      'ruang_kuliah': _ruangController.text,
      'waktu_selesai': _waktuSelesaiController.text,
      'keterangan_ruang': _keteranganRuangController.text,
      'jenis_pertemuan': _jenisPertemuan,
      'url_kuliah_online': _urlOnlineController.text,
      'status': _status,
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_adminToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dibuat')),
        );
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      } else {
        final resBody = jsonDecode(response.body);
        final errorMsg = resBody['message'] ?? 'Terjadi kesalahan saat membuat jadwal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buka Kelas Baru'),
        backgroundColor: const Color(0xFF90CAF9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Detail Jadwal / Judul
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Detail Jadwal (Judul)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Judul harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // Sesi
              TextFormField(
                controller: _sesiController,
                decoration: const InputDecoration(
                  labelText: 'Sesi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Sesi harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // Metode
              TextFormField(
                controller: _metodeController,
                decoration: const InputDecoration(
                  labelText: 'Metode',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Metode harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // Tanggal Jadwal
              InkWell(
                onTap: _pickTanggal,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Jadwal',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                child: Text(
                  _tanggalJadwal == null
                      ? 'Pilih tanggal'
                      : DateFormat('dd MMMM yyyy').format(_tanggalJadwal!),
                ),
                ),
              ),
              const SizedBox(height: 16),

              // Ruang Kuliah
              TextFormField(
                controller: _ruangController,
                decoration: const InputDecoration(
                  labelText: 'Ruang Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Ruang kuliah harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // Waktu Selesai
              InkWell(
                onTap: _pickWaktuSelesai,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Waktu Selesai',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    _waktuSelesaiController.text.isEmpty
                        ? 'Pilih waktu selesai'
                        : _waktuSelesaiController.text,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Keterangan Ruang Kuliah
              TextFormField(
                controller: _keteranganRuangController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Ruang Kuliah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Jenis Pertemuan (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Pertemuan',
                  border: OutlineInputBorder(),
                ),
                value: _jenisPertemuan,
                items: jenisPertemuanList
                    .map((jp) => DropdownMenuItem(value: jp, child: Text(jp)))
                    .toList(),
                onChanged: (val) => setState(() => _jenisPertemuan = val),
                validator: (value) => value == null ? 'Jenis pertemuan harus dipilih' : null,
              ),
              const SizedBox(height: 16),

              // URL Kuliah Online
              TextFormField(
                controller: _urlOnlineController,
                decoration: const InputDecoration(
                  labelText: 'URL Kuliah Online',
                  border: OutlineInputBorder(),
                ),
                enabled: _status == 'Online',
                validator: (value) {
                  if (_status == 'Online' && (value == null || value.isEmpty)) {
                    return 'URL harus diisi jika status Online';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: _status,
                items: statusList
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _status = val;
                    if (_status == 'Offline') {
                      _urlOnlineController.clear();
                    }
                  });
                },
                validator: (value) => value == null ? 'Status harus dipilih' : null,
              ),

              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Simpan Jadwal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
