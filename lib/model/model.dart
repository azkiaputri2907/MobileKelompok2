// lib/model/model.dart

class JadwalDosenHariIni {
  final int idKelasMk;
  final String mataKuliah;
  final String namaKelas;
  final String waktuMulai;
  final String waktuSelesai;
  final String namaRuang;
  final int sks;
  final String pertemuanInfo;

  JadwalDosenHariIni({
    required this.idKelasMk,
    required this.mataKuliah,
    required this.namaKelas,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.namaRuang,
    required this.sks,
    required this.pertemuanInfo,
  });
}

class KelasMK {
  final String mataKuliah;
  final String kelas;
  final int jumlahPertemuan;

  KelasMK({
    required this.mataKuliah,
    required this.kelas,
    required this.jumlahPertemuan,
  });
}