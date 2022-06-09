import 'package:aplikasi_presensi/themes.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

int currentIndex = 2;

class _BottomNavState extends State<BottomNav> {
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
            label: 'student',
          ),
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          currentIndex = value;

          switch (value) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/sheet', (route) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/class', (route) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/student', (route) => false);
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
