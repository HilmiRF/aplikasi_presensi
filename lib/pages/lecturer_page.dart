// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/authentication_services.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:aplikasi_presensi/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../themes.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({Key? key}) : super(key: key);

  @override
  State<LecturerPage> createState() => _LecturerPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
User? user;
var myUid;
// String myUid = '';
String imageUrl = '';
String namaDosen = '';

class _LecturerPageState extends State<LecturerPage> {
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      user = auth.currentUser;
      myUid = user?.uid;
      // do whatever you want based on the firebaseUser state
      imageUrl = getImageUrl().toString();
      namaDosen = getNamaDosen().toString();
    });
    // myUid = getUid().toString();
    // imageUrl = getImageUrl().toString();
    // namaDosen = getNamaDosen().toString();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  final double profileHeight = 100;
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
            profile(),
            detail(),
            signOut(),
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
            'Lecturers\nPage',
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

  Widget profile() {
    return Container(
      margin: EdgeInsets.only(
        top: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: kWhiteColor,
            backgroundImage: imageUrl.isEmpty
                ? null
                : NetworkImage(
                    imageUrl,
                    scale: 6,
                  ),
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            namaDosen,
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget detail() {
    return Container(
      margin: EdgeInsets.only(
        top: 32,
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semester',
                  style: blackTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Gasal',
                  style: greyTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tahun Ajaran',
                  style: blackTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '2022-2023',
                  style: greyTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget signOut() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.only(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kBlackColor,
      ),
      child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
          // await FirebaseAuth.instance.signOut();
          // handleSignOut();
          // Navigator.pop(context);
          // context.read<AuthenticationService>().signOut();
        },
        child: Text(
          'Sign Out',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }

  Future<String> getImageUrl() async {
    FirebaseFirestore.instance
        .collection('dosen')
        .where('uid', isEqualTo: myUid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          imageUrl = doc['image_url'];
        });
        // imageUrl = doc['image_url'];
      });
    });
    print(imageUrl);
    print(myUid);
    return imageUrl;
  }

  Future<String> getNamaDosen() async {
    FirebaseFirestore.instance
        .collection('dosen')
        .where('uid', isEqualTo: myUid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          namaDosen = doc['nama_dosen'].toString();
        });
        // imageUrl = doc['image_url'];
      });
    });
    print(namaDosen);
    print(myUid);
    return namaDosen;
  }

  Future<String> getUid() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
    return user!.uid;
  }
}
