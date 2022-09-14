// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:aplikasi_presensi/model/Absen.dart';
import 'package:aplikasi_presensi/pages/sheets_page.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_presensi/pages/detail_kelas_page.dart';

import '../themes.dart';

class RekapPresensiPage extends StatefulWidget {
  final String namaKelas;
  final String idKelas;
  const RekapPresensiPage(
      {Key? key, required this.namaKelas, required this.idKelas})
      : super(key: key);

  @override
  State<RekapPresensiPage> createState() => _RekapPresensiPageState();
}

class _RekapPresensiPageState extends State<RekapPresensiPage> {
  late final Stream<QuerySnapshot> kelas =
      FirebaseFirestore.instance.collection(namaKelasValue).snapshots();
  String namaKelasValue = '';
  String idKelasValue = '';
  late List presensi;
  String? value;
  String dropdownValue = '';
  String valueSubstring = '1';

  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.reference();
    var getValue = await value.child(namaKelasValue).once();
    return getValue;
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase();
    readAbsen();
    print(idKelasValue);
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
            dropdownSesi(),
            tabelBaru(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    namaKelasValue = widget.namaKelas;
    idKelasValue = widget.idKelas;
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

  Widget dropdownSesi() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kWhiteColor,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('presensi')
              .where('id_matkul', isEqualTo: idKelasValue)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading.....");
            }
            final data = snapshot.requireData;
            List<DropdownMenuItem<String>> matkulItems = [];
            for (int i = 0; i < data.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              matkulItems.add(
                DropdownMenuItem(
                  child: Text(
                    'Sesi ${snap['sesi']}',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: ('Sesi ${snap['sesi']}'),
                ),
              );
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  hint: Text(
                    'Choose Session',
                    style: greyTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: value,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  isExpanded: true,
                  items: matkulItems,
                  onChanged: (value) {
                    setState(() {
                      this.value = value.toString();
                      dropdownValue = value.toString();
                      valueSubstring = value!.substring(5);
                      print(valueSubstring);
                    });
                  }),
            );
          }),
    );
  }

  Widget tabelBaru() {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kLineDarkColor,
      ),
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(8),
      child: FutureBuilder(
        future: readAbsen(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong!');
          } else if (snapshot.hasData) {
            final absen = snapshot.data!;
            // var userDocument = snapshot.data;
            int arrayLength = absen[0].get('presensi').length;
            return ListView.builder(
              itemCount: arrayLength,
              // itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return Card(
                    child: ListTile(
                  title: Text(
                    (snapshot.data![0]['presensi'][index]['nama_mahasiswa'])
                        .toString(),
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                  subtitle: Text(
                    'NIM: ${(snapshot.data![0]['presensi'][index]['nim_mahasiswa']).toString()}, Waktu Absen: ${((snapshot.data![0]['presensi'][index]['Waktu Absen']) as Timestamp).toDate()}',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ));
                // return Text((snapshot.data![index]['test'][index]
                //         ['nama_mahasiswa'])
                //     .toString());
              },
              // children: absen.map(buildAbsen).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget tabel() {
    var kelas = FirebaseFirestore.instance
        .collection('presensi')
        .where('id_matkul', isEqualTo: idKelasValue)
        .snapshots();
    print(idKelasValue);
    // final result = FirebaseFirestore.instance
    //     .collection('presensi')
    //     .where('id_matkul', isEqualTo: idKelasValue)
    //     .get()
    //     .then((docSnapchot) => {
    //           print(docSnapchot.data['test']),
    //         });
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

            List map = [];

            // get array length
            print(snapshot.requireData.docs[0].get('test').length);

            var chunks = [];
            int chunkSize = 3;
            final data = snapshot.requireData;
            // final testArray = map(snapshot.data!['test']);
            // var arrayLength = data['test'].size;
            for (int i = 0; i < data.size; i++) {
              var date = (snapshot.data!.docs[0]['test'][i]['Waktu Absen']
                      as Timestamp)
                  .toDate();
              map.add(i + 1);
              map.add(
                  '${snapshot.data!.docs[0]['test'][i]['nama_mahasiswa']}, ${snapshot.data!.docs[0]['test'][i]['nim_mahasiswa']}');
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

  // Stream<QuerySnapshot<Map<String, dynamic>>> readAbsen() {
  //   var test = FirebaseFirestore.instance
  //       .collection('presensi')
  //       .where('id_matkul', isEqualTo: idKelasValue)
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => Absen.fromJson(doc.data())).toList());
  //   print(test);
  //   return test;
  // }

  Widget buildAbsen(Absen absen) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: kLineDarkColor,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                absen.presensi.namaMahasiswa,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              subtitle: Text(
                'NIM: ${absen.presensi.nimMahasiswa}, Waktu Absen: ${absen.presensi.waktuAbsen}',
                style: greyTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> readAbsen() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('presensi')
        .where('id_matkul', isEqualTo: idKelasValue)
        .where('sesi', isEqualTo: valueSubstring)
        .get();
    // var test = FirebaseFirestore.instance
    //     .collection('presensi')
    //     .where('id_matkul', isEqualTo: idKelasValue)
    //     .get();
    // .map((snapshot) =>
    //     snapshot.docs.map((doc) => Absen.fromJson(doc.data())).toList());
    print(qn.docs);
    return qn.docs;
  }
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
