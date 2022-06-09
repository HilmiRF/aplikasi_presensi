import 'package:aplikasi_presensi/matkul_data_api.dart';
import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailKelas extends StatefulWidget {
  final DocumentSnapshot post;
  const DetailKelas({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailKelas> createState() => _DetailKelasState();
}

class _DetailKelasState extends State<DetailKelas> {
  final DataRepository repository = DataRepository();
  final Stream<QuerySnapshot> matkul =
      FirebaseFirestore.instance.collection('matkul').snapshots();
  @override
  void initState() {
    super.initState();
    getMatkulList();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
        backgroundColor: kWhiteGreyColor,
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            detailMatkul(),
            rekapPresensiButton(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: EdgeInsets.only(
        top: 38,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post['nama_kelas'],
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 87,
                height: 4,
                margin: EdgeInsets.only(
                  right: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kBlackColor,
                ),
              ),
              Container(
                width: 8,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kBlackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailMatkul() {
    return Container(
      margin: EdgeInsets.only(
        top: 28,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kode Mata Kuliah',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['kode_kelas'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKS Mata Kuliah',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['sks_kelas'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hari Mata Kuliah',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['hari_kelas'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waktu Mata Kuliah',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['waktu_kelas_mulai'] +
                    ' - ' +
                    widget.post['waktu_kelas_selesai'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ruang Mata Kuliah',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['ruang_kelas'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jumlah Peserta MA',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                widget.post['jumlah_mhs'],
                style: greyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget rekapPresensiButton() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top: 28),
      padding: EdgeInsets.only(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kBlackColor,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Lihat Rekap Presensi',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  getMatkulList() async {
    var collection = FirebaseFirestore.instance.collection('matkul');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var namaMatkul = data['nama_kelas'];
      var kodeMatkul = data['kode_kelas'];
      var sksMatkul = data['sks_kelas'];
      var waktuMulaiMatkul = data['waktu_kelas_mulai'];
      var waktuSelesaiMatkul = data['waktu_kelas_selesai'];
      var hariMatkul = data['hari_kelas'];
      var jumlahMHS = data['jumlah_mhs'];
      var ruangMatkul = data['ruang_kelas'];
    }
  }
}
