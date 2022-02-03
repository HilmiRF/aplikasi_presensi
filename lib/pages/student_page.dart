import 'package:aplikasi_presensi/themes.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
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
              } else if (value == 1) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/class', (route) => false);
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
            addStudent(),
            registerStudent(),
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
            'Students\nPage',
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

  Widget addStudent() {
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
          Navigator.pushNamed(context, '/addStudent');
        },
        child: Text(
          'Add Student to Class',
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget registerStudent() {
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
          Navigator.pushNamed(context, '/registerStudent');
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
