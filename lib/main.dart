// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/authentication_services.dart';
import 'package:aplikasi_presensi/model/detail_kelas.dart';
import 'package:aplikasi_presensi/pages/add_class.dart';
import 'package:aplikasi_presensi/pages/add_student.dart';
import 'package:aplikasi_presensi/pages/class_page.dart';
import 'package:aplikasi_presensi/pages/detail_kelas_page.dart';
import 'package:aplikasi_presensi/pages/lecturer_page.dart';
import 'package:aplikasi_presensi/pages/login_page.dart';
import 'package:aplikasi_presensi/pages/register_student.dart';
import 'package:aplikasi_presensi/pages/rekap_presensi_page.dart';
import 'package:aplikasi_presensi/pages/sheets_page.dart';
import 'package:aplikasi_presensi/pages/splash_screen.dart';
import 'package:aplikasi_presensi/pages/student_page.dart';
import 'package:aplikasi_presensi/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthenticationWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        // '/authentication': (context) => AuthenticationWrapper(),
        '/login': (context) => LoginPage(),
        '/student': (context) => StudentPage(),
        // '/class': (context) => ClassPage(),
        // '/sheet': (context) => SheetsPage(),
        '/addStudent': (context) => AddStudent(),
        '/registerStudent': (context) => RegisterStudent(),
        '/addClass': (context) => AddClass(),
        '/lecturer': (context) => LecturerPage(),
        // '/rekap' : (context) => RekapPresensiPage(),
      },
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;
//     var myUid;

//     FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
//       user = auth.currentUser;
//       myUid = user?.uid;
//       print(myUid);
//       // do whatever you want based on the firebaseUser state
//     });

//     final firebaseUser = context.watch<User>();

//     if (firebaseUser != null) {
//       return ClassPage(myUid: myUid);
//     }
//     return LoginPage();
//   }
// }
