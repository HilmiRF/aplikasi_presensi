import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final Stream<QuerySnapshot> matkul =
      FirebaseFirestore.instance.collection('matkul').snapshots();
  String? value;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteGreyColor,
        bottomNavigationBar: BottomNav(),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            chooseClass(),
            tapNFC(),
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
            'Add Student\nto Class',
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
              return Text("Loading....");
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
                    value: (snap['nama_kelas'])),
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
                    });
                  }),
            );
          }),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      );

  Widget tapNFC() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kBlackColor,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Tap Student Card',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
