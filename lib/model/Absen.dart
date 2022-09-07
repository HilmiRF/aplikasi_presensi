class Absen {
  final String idPresensi;
  final String idJadwal;
  final String idMatkul;
  final Presensi presensi;

  Absen({
    required this.idPresensi,
    required this.idJadwal,
    required this.idMatkul,
    required this.presensi,
  });

  Map<String, dynamic> toJson() => {
        'id': idPresensi,
        'id_jadwal': idJadwal,
        'id_matkul': idMatkul,
        'test': presensi.toJson(),
      };

  static Absen fromJson(Map<String, dynamic> json) => Absen(
        idPresensi: json['nama_mahasiswa'],
        idJadwal: json['id_jadwal'],
        idMatkul: json['id_matkul'],
        presensi: Presensi.fromJson(json['test']),
      );
}

class Presensi {
  final String namaMahasiswa;
  final String nimMahasiswa;
  final String waktuAbsen;
  final String idMahasiswa;

  Presensi({
    required this.namaMahasiswa,
    required this.nimMahasiswa,
    required this.waktuAbsen,
    required this.idMahasiswa,
  });

  Map<String, dynamic> toJson() => {
        'nama_mahasiswa': namaMahasiswa,
        'nim_mahasiswa': nimMahasiswa,
        'Waktu Absen': waktuAbsen,
        'id_mhs': idMahasiswa,
      };
  static Presensi fromJson(Map<String, dynamic> json) => Presensi(
        namaMahasiswa: json['nama_mahasiswa'],
        nimMahasiswa: json['nim_mahasiswa'],
        idMahasiswa: json['id_mhs'],
        waktuAbsen: json['Waktu Absen'],
      );
}
