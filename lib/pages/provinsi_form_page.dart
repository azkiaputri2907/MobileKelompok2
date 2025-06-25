import 'package:flutter/material.dart';
import 'package:mobile_kelompok2/service/provinsi_service.dart';
import '../model/provinsi.dart';
import '../services/provinsi_service.dart';

class ProvinsiFormPage extends StatefulWidget {
  final Provinsi? provinsi;
  ProvinsiFormPage({this.provinsi});
  @override
  _ProvinsiFormPageState createState() => _ProvinsiFormPageState();
}

class _ProvinsiFormPageState extends State<ProvinsiFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.provinsi != null) {
      _namaController.text = widget.provinsi!.namaProvinsi;
    }
  }

  Future<void> _saveProvinsi() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (widget.provinsi == null) {
        await ProvinsiService.create(_namaController.text);
      } else {
        await ProvinsiService.update(widget.provinsi!.id, _namaController.text);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan provinsi')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.provinsi == null ? 'Tambah Provinsi' : 'Edit Provinsi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Provinsi'),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveProvinsi,
                      child: Text('Simpan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
