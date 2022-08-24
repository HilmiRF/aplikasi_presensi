// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SheetsPage extends StatefulWidget {
  const SheetsPage({Key? key}) : super(key: key);

  @override
  State<SheetsPage> createState() => _SheetsPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final myUid = user?.uid;
var matkul;

class _SheetsPageState extends State<SheetsPage> {
  void initState() {
    super.initState();
    // myUid = getUid().toString();
    matkul = getMatkul();
    print(matkul);
  }

  StreamSubscription<NDEFMessage>? _stream;
  final Stream<QuerySnapshot<Map<String, dynamic>>> kelas = FirebaseFirestore
      .instance
      .collection('matkul')
      .where(FieldPath.documentId, whereIn: matkul)
      .snapshots();

  String? value;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String valueNama = '';
  String valueNIM = '';
  String valueNama1 = '';
  String valueNIM1 = '';
  String dropdownValue = '';
  String holder = '';
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
                  onChanged: (value) {
                    setState(() {
                      this.value = value.toString();
                      dropdownValue = value.toString();
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
                                  FirebaseFirestore.instance
                                      .collection(dropdownValue)
                                      .doc()
                                      .set({
                                    'Nama & NIM': valueNama1 + ', ' + valueNIM1,
                                    'Waktu Absen': Timestamp.now()
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
          // _tagRead();
          _startScanning();
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

  // void _startScanning() {
  //   setState(() {
  //     _stream = NFC.readNDEF().listen((NDEFMessage message) { })
  //   });
  // }

  void _startScanning() {
    setState(() {
      _stream = NFC
          .readNDEF(alertMessage: "Custom message with readNDEF#alertMessage")
          .listen((NDEFMessage message) {
        if (message.isEmpty) {
          print("Read empty NDEF message");
          return;
        }
        print("Read NDEF message with ${message.records.length} records");
        for (NDEFRecord record in message.records) {
          print(
              "Record '${record.id ?? "[NO ID]"}' with TNF '${record.tnf}', type '${record.type}', payload '${record.payload}' and data '${record.data}' and language code '${record.languageCode}'");
          FirebaseFirestore.instance.collection(dropdownValue).doc().set(
              {'Nama & NIM': record.data, 'Waktu Absen': Timestamp.now()},
              SetOptions(merge: true)).then((value) {});
          print(record.data);
        }
      }, onError: (error) {
        setState(() {
          _stream = null;
        });
        if (error is NFCUserCanceledSessionException) {
          print("user canceled");
        } else if (error is NFCSessionTimeoutException) {
          print("session timed out");
        } else {
          print("error: $error");
        }
      }, onDone: () {
        setState(() {
          _stream = null;
        });
      });
    });
  }

  // void _tagRead() {
  //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     result.value = tag.data;
  //     FirebaseFirestore.instance.collection(dropdownValue).doc().set(
  //       {'Nama & NIM': tag.data, 'Waktu Absen': Timestamp.now()},
  //     SetOptions(merge: true)).then((value) {});
  //     NfcManager.instance.stopSession();
  //   });
  // }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  Future<List> getMatkul() async {
    FirebaseFirestore.instance
        .collection('dosen')
        .where('uid', isEqualTo: myUid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          matkul = doc['array_matkul'];
        });
        // imageUrl = doc['image_url'];
      });
    });
    print(matkul);
    print(myUid);
    return matkul;
  }
}
