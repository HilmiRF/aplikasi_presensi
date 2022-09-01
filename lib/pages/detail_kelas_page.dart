// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/matkul_data_api.dart';
import 'package:aplikasi_presensi/pages/rekap_presensi_page.dart';
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
  String namaKelas = '';
  var hari;
  var waktuMulai;
  var waktuSelesai;
  var ruang;
  var semester;
  var tahun;

  @override
  void initState() {
    super.initState();
    // getMatkulList();
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
            detailMatkulBaru(),
            rekapPresensiButton(),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget title() {
    namaKelas = widget.post['nama_kelas'];
    return Container(
      margin: EdgeInsets.only(
        top: 38,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaKelas,
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

  // Widget detailMatkul lama tidak dipakai lagi
  Widget detailMatkul() {
    // getMatkulList();
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
                hari.toString(),
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

  Widget detailMatkulBaru() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jadwal')
            .where('id_matkul', isEqualTo: widget.post.id)
            .snapshots(),
        builder: ((
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          final data = snapshot.requireData;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.size,
            itemBuilder: (context, index) {
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
                        )
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
                        )
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
                          data.docs[index]['hari'],
                          style: greyTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        )
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
                          "${data.docs[index]['waktu_kelas_mulai']} - ${data.docs[index]['waktu_kelas_selesai']}",
                          style: greyTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        )
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
                          data.docs[index]['ruang'],
                          style: greyTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Semester Mata Kuliah',
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        Text(
                          data.docs[index]['semester'],
                          style: greyTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tahun Mata Kuliah',
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        Text(
                          data.docs[index]['tahun'],
                          style: greyTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
            },
          );
        }),
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
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RekapPresensiPage(
                  namaKelas: namaKelas,
                ),
              ));
        },
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

  // getMatkulList() async {
  //   var collection = FirebaseFirestore.instance.collection('jadwal');
  //   var docSnapshot =
  //       await collection.where('id_matkul', isEqualTo: widget.post.id).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic> data = docSnapshot.data()!;

  //     hari = data['hari'];
  //     waktuMulai = data['waktu_kelas_mulai'];
  //     waktuSelesai = data['waktu_kelas_selesai'];
  //     ruang = data['ruang'];
  //     semester = data['semester'];
  //     tahun = data['tahun'];
  //   }
  //   print(hari);
  //   print(waktuMulai);
  //   print(waktuSelesai);
  //   print(ruang);
  //   print(semester);
  //   print(tahun);
  //   print("${widget.post.id} hehe");
  // }
}
