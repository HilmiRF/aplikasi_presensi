// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_presensi/pages/detail_kelas_page.dart';

import '../themes.dart';

class RekapPresensiPage extends StatefulWidget {
  final String namaKelas;
  const RekapPresensiPage({Key? key, required this.namaKelas})
      : super(key: key);

  @override
  State<RekapPresensiPage> createState() => _RekapPresensiPageState();
}

class _RekapPresensiPageState extends State<RekapPresensiPage> {
  late final Stream<QuerySnapshot> kelas =
      FirebaseFirestore.instance.collection(namaKelasValue).snapshots();
  String namaKelasValue = '';

  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.reference();
    var getValue = await value.child(namaKelasValue).once();
    return getValue;
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase();
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
            tabel(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    namaKelasValue = widget.namaKelas;
    return Container(
      margin: EdgeInsets.only(
        top: 38,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaKelasValue,
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

  Widget tabel() {
    var kelas =
        FirebaseFirestore.instance.collection(namaKelasValue).snapshots();
    return Container(
      margin: EdgeInsets.only(
        top: 28,
        bottom: 28,
      ),
      child: StreamBuilder(
          stream: kelas,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }

            // map = snapshot.data!.docs;
            final result = FirebaseFirestore.instance
                .collection(namaKelasValue)
                .snapshots();
            List map = [];
            var chunks = [];
            int chunkSize = 3;
            final data = snapshot.requireData;
            for (int i = 0; i < data.size; i++) {
              var date = (snapshot.data!.docs[i]['Waktu Absen'] as Timestamp).toDate();
              map.add(i + 1);
              map.add(snapshot.data!.docs[i]['Nama & NIM']);
              map.add(date);
            }
            for (var i = 0; i < map.length; i += chunkSize) {
              chunks.add(map.sublist(
                  i, i + chunkSize > map.length ? map.length : i + chunkSize));
            }
            print(chunks);
            print(chunks.length);
            return Table(
              border:
                  TableBorder.all(color: kBlackColor, style: BorderStyle.solid),
              columnWidths: {
                0: FractionColumnWidth(0.125),
                1: FractionColumnWidth(0.375),
                2: FractionColumnWidth(0.375),
              },
              children: [
                buildRow(['No', 'Nama & NIM', 'Waktu Presensi'],
                    isHeader: true),
                for (var i = 0; i < chunks.length; i++) buildRow(chunks[i]),
              ],
            );
          }),
    );
  }

  TableRow buildRow(List cells, {bool isHeader = false}) => TableRow(
        children: cells.map((cell) {
          final style = blackTextStyle.copyWith(
            fontWeight: isHeader ? bold : regular,
            fontSize: 18,
          );
          return Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                cell.toString(),
                style: style,
              ),
            ),
          );
        }).toList(),
      );
}

class Data {
  final String namaNIM;
  final String timeStamp;

  Data({required this.namaNIM, required this.timeStamp});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      namaNIM: json['Nama & NIM'],
      timeStamp: json['Waktu Absen'],
    );
  }
}
