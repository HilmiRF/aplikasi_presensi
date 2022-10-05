// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/pages/class_page.dart';
import 'package:aplikasi_presensi/pages/sheets_page.dart';
import 'package:aplikasi_presensi/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

int currentIndex = 1;
final FirebaseAuth auth = FirebaseAuth.instance;
User? user;
var myUid;

class _BottomNavState extends State<BottomNav> {
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      user = auth.currentUser;
      myUid = user?.uid;
      print(myUid);
    });
    // myUid = getUid().toString();
    // imageUrl = getImageUrl().toString();
    // namaDosen = getNamaDosen().toString();
  }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Image.asset('assets/sheets_active.png', width: 24)
                : Image.asset('assets/sheets.png', width: 24),
            label: 'sheets',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Image.asset('assets/class_active.png', width: 24)
                : Image.asset('assets/class.png', width: 24),
            label: 'class',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? Image.asset('assets/student_active.png', width: 24)
                : Image.asset('assets/student.png', width: 24),
            label: 'lecturer',
          ),
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          currentIndex = value;
          switch (value) {
            case 0:
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SheetsPage(
                      myUid: myUid,
                    ),
                  ),
                  (route) => false);
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ClassPage(
                      myUid: myUid,
                    ),
                  ),
                  (route) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/lecturer', (route) => false);
              break;
          }

          setState(() {
            currentIndex = value;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
