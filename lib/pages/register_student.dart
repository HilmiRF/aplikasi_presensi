import 'dart:async';
import 'dart:io';

import 'package:aplikasi_presensi/themes.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({Key? key}) : super(key: key);

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  StreamSubscription<NDEFMessage>? _stream;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  late String valueNama;
  late String valueNIM;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteGreyColor,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: kWhiteColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (value) {
              if (value == 0) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/sheet', (route) => false);
              } else if (value == 1) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/class', (route) => false);
              } else {
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
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            namaInput(),
            nimInput(),
            registerButton(),
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
            'Register Your\nCard',
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

  Widget namaInput() {
    return Container(
      margin: EdgeInsets.only(
        top: 28,
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
            return 'NIM';
          }
          return null;
        },
      ),
    );
  }

  Widget nimInput() {
    return Container(
      margin: EdgeInsets.only(
        top: 28,
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
    );
  }

  Widget registerButton() {
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
        onPressed: () async {
          valueNama = namaController.text;
          valueNIM = nimController.text;
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
          bool isAvailable = await NfcManager.instance.isAvailable();
          NfcManager.instance.startSession(
            onDiscovered: (NfcTag tag) async {
              var ndef = Ndef.from(tag);
              if (ndef == null || !ndef.isWritable) {
                NfcManager.instance.stopSession(errorMessage: result.value);
                return;
              }
              NdefMessage messageNama = NdefMessage([
                NdefRecord.createText('$valueNama, $valueNIM'),
              ]);
              try {
                await ndef.write(messageNama);
                result.value = 'Success to "Ndef Write"';
                NfcManager.instance.stopSession();
              } catch (e) {
                result.value = e;
                NfcManager.instance
                    .stopSession(errorMessage: result.value.toString());
                return;
              }
            },
          );
        },
        child: Text(
          'Register Student Card',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
