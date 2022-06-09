import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> firestore =
    FirebaseFirestore.instance.collection('matkul').snapshots();

class DetailMatkul {
  final String namaMatkul;
  final String kodeMatkul;
  final String sksMatkul;
  final String waktuMulaiMatkul;
  final String waktuSelesaiMatkul;
  final String ruangMatkul;
  final String jumlahMHS;
  final String hariMatkul;

  DetailMatkul({
    required this.namaMatkul,
    required this.kodeMatkul,
    required this.sksMatkul,
    required this.waktuMulaiMatkul,
    required this.hariMatkul,
    required this.jumlahMHS,
    required this.ruangMatkul,
    required this.waktuSelesaiMatkul,
  });

  DetailMatkul.fromMap(Map<String, dynamic> detailMatkulMap)
      : namaMatkul = detailMatkulMap['nama_kelas'],
        kodeMatkul = detailMatkulMap['kode_kelas'],
        sksMatkul = detailMatkulMap['sks_kelas'],
        waktuMulaiMatkul = detailMatkulMap['waktu_kelas_mulai'],
        waktuSelesaiMatkul = detailMatkulMap['waktu_kelas_selesai'],
        hariMatkul = detailMatkulMap['hari_kelas'],
        jumlahMHS = detailMatkulMap['jumlah_mhs'],
        ruangMatkul = detailMatkulMap['ruang_kelas'];

  Map<String, dynamic> toMap() {
    return {
      'nama_kelas': namaMatkul,
      'kode_kelas': kodeMatkul,
      'sks_kelas': sksMatkul,
      'waktu_kelas_mulai': waktuMulaiMatkul,
      'waktu_kelas_selesai': waktuSelesaiMatkul,
      'hari_kelas': hariMatkul,
      'jumlah_mhs': jumlahMHS,
      'ruang_kelas': ruangMatkul,
    };
  }

  // static List<DetailMatkul> fetchAll() {
  //   return [
  //     DetailMatkul(
  //       'namaMatkul1',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul2',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul3',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul4',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul5',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul6',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul7',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //     DetailMatkul(
  //       'namaMatkul8',
  //       'kodeMatkul',
  //       'sksMatkul',
  //       'waktuMulaiMatkul',
  //       'hariMatkul',
  //       'jumlahMHS',
  //       'ruangMatkul',
  //       'waktuSelesaiMatkul',
  //     ),
  //   ];
  // }
  // DetailMatkul({
  //   required this.namaMatkul,
  //   required this.kodeMatkul,
  //   required this.sksMatkul,
  //   required this.waktuMulaiMatkul,
  //   required this.hariMatkul,
  //   required this.jumlahMHS,
  //   required this.ruangMatkul,
  //   required this.waktuSelesaiMatkul,
  // });
}

List getMatkul() {
  return [
    DetailMatkul(
      namaMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['nama_kelas']);
        }
      }).toString(),
      kodeMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['kode_kelas']);
        }
      }).toString(),
      sksMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['sks_kelas']);
        }
      }).toString(),
      waktuMulaiMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['waktu_kelas_mulai']);
        }
      }).toString(),
      hariMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['hari_kelas']);
        }
      }).toString(),
      jumlahMHS: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['jumlah_mhs']);
        }
      }).toString(),
      ruangMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['ruang_kelas']);
        }
      }).toString(),
      waktuSelesaiMatkul: FirebaseFirestore.instance
          .collection('matkul')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          return (doc['waktu_kelas_selesai']);
        }
      }).toString(),
    )
  ];
}
