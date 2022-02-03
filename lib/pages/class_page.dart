// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final Stream<QuerySnapshot> matkul =
      FirebaseFirestore.instance.collection('matkul').snapshots();

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
              if (value == 0) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/sheet', (route) => false);
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
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            classList(),
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
            'Classes\nPage',
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

  Widget classList() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kLineDarkColor,
      ),
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(8),
      child: Scrollbar(
        radius: Radius.circular(50),
        child: StreamBuilder<QuerySnapshot>(
          stream: matkul,
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

            final data = snapshot.requireData;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      data.docs[index]['nama_kelas'],
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget addClass() {
    return Container(
      height: 56,
      width: double.infinity,
      margin: EdgeInsets.only(top: 32),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addClass');
        },
        child: Text(
          'Add Class',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: kBlackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
