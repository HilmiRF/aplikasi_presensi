// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:aplikasi_presensi/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SheetsPage extends StatefulWidget {
  const SheetsPage({Key? key}) : super(key: key);

  @override
  State<SheetsPage> createState() => _SheetsPageState();
}

class _SheetsPageState extends State<SheetsPage> {
  StreamSubscription<NDEFMessage>? _stream;
  final Stream<QuerySnapshot> matkul =
      FirebaseFirestore.instance.collection('matkul').snapshots();
  String? value;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String valueNama = '';
  String valueNIM = '';
  String dropdownValue = '';
  String holder = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: kWhiteColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (value) {
              if (value == 1) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/class', (route) => false);
              } else if (value == 2) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/student', (route) => false);
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/sheets.png',
                    width: 24,
                  ),
                  label: 'sheets'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/class.png',
                    width: 24,
                  ),
                  label: 'class'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/student.png',
                    width: 24,
                  ),
                  label: 'student'),
            ],
          ),
        ),
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
          stream: matkul,
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
          getDropDownItem();
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
          FirebaseFirestore.instance
              .collection(dropdownValue)
              .doc()
              .set({'Nama & NIM': record.data, 'Waktu Absen': Timestamp.now()},
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
}
