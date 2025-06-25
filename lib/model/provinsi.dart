class Provinsi {
  final int id;
  final String namaProvinsi;

  Provinsi({
    required this.id,
    required this.namaProvinsi,
  });

  factory Provinsi.fromJson(Map<String, dynamic> json) {
    return Provinsi(
      id: json['id'],
      namaProvinsi: json['nama_provinsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_provinsi': namaProvinsi,
    };
  }
}
