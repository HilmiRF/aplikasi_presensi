// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, prefer_collection_literals, unnecessary_new

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:aplikasi_presensi/model/Absen.dart';
import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SheetsPage extends StatefulWidget {
  final String myUid;
  const SheetsPage({Key? key, required this.myUid}) : super(key: key);

  @override
  State<SheetsPage> createState() => _SheetsPageState();
}

var matkul;

class _SheetsPageState extends State<SheetsPage> {
  @override
  void initState() {
    super.initState();
    // myUid = getUid().toString();
    matkul = getMatkul();
    print(matkul);
  }

  final Stream<QuerySnapshot<Map<String, dynamic>>> kelas = FirebaseFirestore
      .instance
      .collection('matkul')
      .where(FieldPath.documentId, whereIn: matkul)
      .snapshots();

  // final Stream<QuerySnapshot<Map<String, dynamic>>> jadwal = FirebaseFirestore
  //     .instance
  //     .collection('jadwal')
  //     .where('id_matkul', isEqualTo: dropdownValueID)
  //     .snapshots();

  String? value;
  String? valueDay;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String valueNama = '';
  String valueNIM = '';
  String valueNama1 = '';
  String valueNIM1 = '';
  String dropdownValue = '';
  String dropdownValueID = '';
  String dropdownDayValue = '';
  String dropdownDayValueID = '';
  String holder = '';
  String holderDay = '';
  int sesi = 1;
  String idPresensi = '';
  String idTrim = '';
  String namaTrim = '';
  String nimTrim = '';
  Map isiNFCWaktu = {};
  List isiNFC = [];
  List presensi = [];
  bool cekID = false;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();

  @override
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
            chooseClass(),
            chooseHari(),
            startAttendance(),
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
            'Sheets\nPage',
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

  Widget chooseClass() {
    return Container(
      margin: EdgeInsets.only(top: 28),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kWhiteColor,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: kelas,
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
                    snap['nama_kelas'],
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: (snap['nama_kelas']),
                ),
              );
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  hint: Text(
                    'Choose Class',
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
                  onChanged: (value) async {
                    dropdownValue = value.toString();
                    // Syntax get id_matkul
                    dropdownValueID = await getDropdownID(dropdownValue);
                    setState(() {
                      this.value = value.toString();
                      dropdownValue = value.toString();
                      print('$dropdownValueID, hehe');
                    });
                  }),
            );
          }),
    );
  }

  Widget chooseHari() {
    return Container(
      margin: EdgeInsets.only(top: 28),
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
              .collection('jadwal')
              .where('id_matkul', isEqualTo: dropdownValueID)
              .where('uid_dosen', isEqualTo: widget.myUid)
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
                    snap['hari'],
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: (snap['hari']),
                ),
              );
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  hint: Text(
                    'Choose Day',
                    style: greyTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: valueDay,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  isExpanded: true,
                  items: matkulItems,
                  onChanged: (valueDay) async {
                    dropdownDayValue = valueDay.toString();
                    // Syntax get id jadwal
                    dropdownDayValueID =
                        await getDropdownDayID(dropdownDayValue);
                    sesi = await getLengthSesi(dropdownValueID);
                    setState(() {
                      this.valueDay = valueDay.toString();
                      dropdownDayValue = valueDay.toString();
                      print('$dropdownDayValueID, hehe');
                    });
                  }),
            );
          }),
    );
  }

  Widget startAttendance() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kBlackColor,
      ),
      child: TextButton(
        onPressed: () async {
          // set document baru di master presensi
          final docPresensi =
              FirebaseFirestore.instance.collection('presensi').doc();
          docPresensi.set({
            'id': docPresensi.id,
            'id_jadwal': dropdownDayValueID,
            'id_matkul': dropdownValueID,
            'sesi': (sesi + 1).toString(),
          });
          idPresensi = docPresensi.id;
          print(idPresensi);
          print(sesi);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: kLineDarkColor,
              title: Text(
                "Place student card on the\nback of the phone",
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
                textAlign: TextAlign.center,
              ),
              content: Image.asset(
                'assets/card.png',
                width: 140,
                height: 140,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              actions: [
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: kBlackColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      _stopScanning();
                      NfcManager.instance.stopSession();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Done',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: kBlackColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: kLineDarkColor,
                          title: Text(
                            "Add Manually",
                            style: blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: semiBold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          actions: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.all(18),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: kWhiteColor,
                              ),
                              child: TextFormField(
                                controller: namaController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Nama Mahasiswa',
                                  hintStyle: greyTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Nama Mahasiswa';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.all(18),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: kWhiteColor,
                              ),
                              child: TextFormField(
                                controller: nimController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'NIM',
                                  hintStyle: greyTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'NIM';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: kBlackColor,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  valueNama1 = namaController.text;
                                  valueNIM1 = nimController.text;
                                  var mapManual = new Map<String, dynamic>();
                                  mapManual["presensi"] = [
                                    {
                                      "id_mhs": 'PRESENSI MANUAL',
                                      "nama_mahasiswa": valueNama1,
                                      "nim_mahasiswa": valueNIM1,
                                      "Waktu Absen": Timestamp.now(),
                                    },
                                  ];
                                  FirebaseFirestore.instance
                                      .collection('presensi')
                                      .doc(idPresensi)
                                      .set({
                                    'presensi': FieldValue.arrayUnion(
                                      mapManual["presensi"],
                                    )
                                  }, SetOptions(merge: true)).then((value) {});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Done',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Add Manually',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          getDropDownItem();
          getDropDownDayItem();
          _tagRead();
          // _startScanning();
        },
        child: Text(
          'Start Attendance',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Read NFC ID
      Map tagData0 = tag.data;
      Map tagNdef0 = tagData0['ndef'];
      Map cachedMessage0 = tagNdef0['cachedMessage'];
      Map records0 = cachedMessage0['records'][0];
      Uint8List payload0 = records0['payload'];
      String payloadAsString0 = String.fromCharCodes(payload0);

      // Read Nama
      Map tagData1 = tag.data;
      Map tagNdef1 = tagData1['ndef'];
      Map cachedMessage1 = tagNdef1['cachedMessage'];
      Map records1 = cachedMessage1['records'][1];
      Uint8List payload1 = records1['payload'];
      String payloadAsString1 = String.fromCharCodes(payload1);

      // Read NIM
      Map tagData2 = tag.data;
      Map tagNdef2 = tagData2['ndef'];
      Map cachedMessage2 = tagNdef2['cachedMessage'];
      Map records2 = cachedMessage2['records'][2];
      Uint8List payload2 = records2['payload'];
      String payloadAsString2 = String.fromCharCodes(payload2);

      // ID, Nama, NIM yang sudah di Trim
      idTrim = payloadAsString0.substring(11);
      namaTrim = payloadAsString1.substring(9);
      nimTrim = payloadAsString2.substring(8);

      var map = new Map<String, dynamic>();
      map["presensi"] = [
        {
          "id_mhs": idTrim,
          "nama_mahasiswa": namaTrim,
          "nim_mahasiswa": nimTrim,
          "Waktu Absen": Timestamp.now(),
        },
      ];

      // function untuk cek ID kalau true store di firestore kalau false show dialog kartu tidak terdaftar.
      cekID = await cekMahasiswa();
      // print(cekID.toString());

      if (cekID == true) {
        FirebaseFirestore.instance.collection('presensi').doc(idPresensi).set({
          'presensi': FieldValue.arrayUnion(
            map["presensi"],
          )
        }, SetOptions(merge: true)).then((value) {});
      } else {
        Fluttertoast.showToast(
          msg: "Kartu Tidak Terdaftar",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Kartu Tidak Terdaftar');
      }

      //

      print(idTrim);
      print(namaTrim);
      print(nimTrim);
    });
  }

  Future<bool> cekMahasiswa() async {
    await FirebaseFirestore.instance
        .collection('jadwal')
        .where('id', isEqualTo: dropdownDayValueID)
        .where('array_mhs', arrayContains: idTrim)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        cekID = false;
      } else {
        cekID = true;
      }
    });
    print(cekID);
    return cekID;
  }

  void _stopScanning() {
    NfcManager.instance.stopSession();
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  void getDropDownDayItem() {
    setState(() {
      holderDay = dropdownDayValue;
    });
  }

  Future<String> getDropdownID(dropdownValue) async {
    var docRef = FirebaseFirestore.instance
        .collection('matkul')
        .where('nama_kelas', isEqualTo: dropdownValue);
    await docRef.get().then((snapshot) {
      dropdownValueID = snapshot.docs[0]['id'].toString();
    });
    return dropdownValueID;
  }

  Future<String> getDropdownDayID(dropdownDayValue) async {
    var docRef = FirebaseFirestore.instance
        .collection('jadwal')
        .where('id_matkul', isEqualTo: dropdownValueID)
        .where('hari', isEqualTo: dropdownDayValue);
    await docRef.get().then((snapshot) {
      dropdownDayValueID = snapshot.docs[0]['id'].toString();
    });
    return dropdownDayValueID;
  }

  Future<int> getLengthSesi(dropdownValueID) async {
    // var docRef = FirebaseFirestore.instance
    //     .collection('jadwal')
    //     .where('id_matkul', isEqualTo: dropdownValueID)
    //     .get();
    // sesi = await (docRef. + 1);
    var sesi = await FirebaseFirestore.instance
        .collection('presensi')
        .where('id_matkul', isEqualTo: dropdownValueID)
        .get()
        .then((result) => result.docs.length);
    ;

    print('$sesi hehe');
    return sesi;
  }

  Future<List<Object>> getMatkul() async {
    await FirebaseFirestore.instance
        .collection('jadwal')
        .where('uid_dosen', isEqualTo: widget.myUid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      matkul = querySnapshot.docs.map((doc) => doc['id_matkul']).toList();
      // querySnapshot.docs.forEach((doc) {
      //   // matkul = matkul.push(doc['id_matkul']);
      //   print(doc['id_matkul']);
      //   // setState(() {
      //   //   matkul = doc['id_matkul'];
      //   // });
      // });
    });
    print(matkul);
    print(myUid);
    return matkul;
  }
}

// Future<List> getMatkul() async {
//   FirebaseFirestore.instance
//       .collection('dosen')
//       .where('uid', isEqualTo: myUid)
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     querySnapshot.docs.forEach((doc) {
//       setState(() {
//         matkul = doc['array_matkul'];
//       });
//       // imageUrl = doc['image_url'];
//     });
//   });
//   print(matkul);
//   print(myUid);
//   return matkul;
// }


