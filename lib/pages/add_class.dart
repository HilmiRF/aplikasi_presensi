// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final Stream<QuerySnapshot> matkul =
      FirebaseFirestore.instance.collection('matkul').snapshots();

  var nama_kelas = '';
  var jam_mulai = '';
  var menit_mulai = '';
  var jam_selesai = '';
  var menit_selesai = '';

  final items = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];
  final jam = [
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
  ];
  final menit = [
    "00",
    "10",
    "20",
    "30",
    "40",
    "50",
  ];
  final jamSelesai = [
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
  ];
  final menitSelesai = [
    "00",
    "10",
    "20",
    "30",
    "40",
    "50",
  ];
  String? value;
  String? valueJam;
  String? valueMenit;
  String? valueJamSelesai;
  String? valueMenitSelesai;

  @override
  Widget build(BuildContext context) {
    CollectionReference matkul =
        FirebaseFirestore.instance.collection('matkul');
    return SafeArea(
      child: Scaffold(
        backgroundColor: kLineDarkColor,
        bottomNavigationBar: BottomNav(),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            kelasInput(),
            SizedBox(
              height: 7,
            ),
            Text(
              'Waktu Mulai',
              style: blackTextStyle.copyWith(
                fontWeight: semiBold,
              ),
            ),
            waktuMulai(),
            SizedBox(
              height: 7,
            ),
            Text(
              'Waktu Selesai',
              style: blackTextStyle.copyWith(
                fontWeight: semiBold,
              ),
            ),
            waktuSelesai(),
            addClass(),
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
            'Add \nClass',
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

  Widget kelasInput() {
    return Container(
      margin: EdgeInsets.only(
        top: 37,
      ),
      padding: EdgeInsets.all(18),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kWhiteColor,
      ),
      child: TextFormField(
        decoration: InputDecoration.collapsed(
          hintText: 'Nama Kelas',
          hintStyle: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
        onChanged: (value) {
          nama_kelas = value;
        },
      ),
    );
  }

  Widget waktuMulai() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 95,
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kWhiteColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    'Hari',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: value,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    setState(() => this.value = value);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 9),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kWhiteColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    'Jam',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: valueJam,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  items: jam.map(buildMenuJam).toList(),
                  onChanged: (valueJam) {
                    setState(() => this.valueJam = valueJam);
                    jam_mulai = valueJam.toString();
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 9),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kWhiteColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    'Menit',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: valueMenit,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  items: menit.map(buildMenuJam).toList(),
                  onChanged: (valueMenit) {
                    setState(() => this.valueMenit = valueMenit);
                    menit_mulai = valueMenit.toString();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuJam(String jam) => DropdownMenuItem(
        value: jam,
        child: Text(
          jam,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuMenit(String menit) => DropdownMenuItem(
        value: menit,
        child: Text(
          menit,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
      );

  Widget waktuSelesai() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 95,
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kWhiteColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    'Jam',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: valueJamSelesai,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  items: jamSelesai.map(buildMenuItem).toList(),
                  onChanged: (valueJamSelesai) {
                    setState(() => this.valueJamSelesai = valueJamSelesai);
                    jam_selesai = valueJamSelesai.toString();
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 9),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kWhiteColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    'Menit',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  value: valueMenitSelesai,
                  icon: Image.asset(
                    'assets/dropdown.png',
                    width: 12,
                  ),
                  items: menitSelesai.map(buildMenuJam).toList(),
                  onChanged: (valueMenitSelesai) {
                    setState(() => this.valueMenitSelesai = valueMenitSelesai);
                    menit_selesai = valueMenitSelesai.toString();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuJamSelesai(String jamSelesai) =>
      DropdownMenuItem(
        value: jamSelesai,
        child: Text(
          jamSelesai,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuMenitSelesai(String menitSelesai) =>
      DropdownMenuItem(
        value: menitSelesai,
        child: Text(
          menitSelesai,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
      );

  Widget addClass() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top: 38),
      padding: EdgeInsets.only(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kBlackColor,
      ),
      child: TextButton(
        onPressed: () {
          FirebaseFirestore.instance.collection('matkul').add({
            'nama_kelas': nama_kelas,
            'jam_mulai': jam_mulai,
            'menit_mulai': menit_mulai,
            'jam_selesai': jam_selesai,
            'menit_selesai': menit_selesai,
          }).then((value) => print('Matkul Added'));
          Navigator.pushNamedAndRemoveUntil(context, '/class', (route) => false);
        },
        child: Text(
          'Add Class',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
