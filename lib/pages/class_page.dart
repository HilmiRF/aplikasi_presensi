// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names

import 'package:aplikasi_presensi/model/detail_kelas.dart';
import 'package:aplikasi_presensi/pages/detail_kelas_page.dart';
import 'package:aplikasi_presensi/themes.dart';
import 'package:aplikasi_presensi/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ClassPage extends StatefulWidget {
  final String myUid;
  const ClassPage({Key? key, required this.myUid}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

// List<Object> matkul;
var matkuls;
var matkul;
// late List mappedMatkul;

class _ClassPageState extends State<ClassPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> kelas;
  @override
  void initState() {
    // myUid = getUid().toString();
    WidgetsBinding.instance.addPostFrameCallback((_) => getMatkul());
    print(myUid);
    print(matkul);
    kelas = FirebaseFirestore.instance
        .collection('matkul')
        .where(FieldPath.documentId, whereIn: matkul)
        .snapshots();
    super.initState();
  }

  // final Stream<QuerySnapshot<Map<String, dynamic>>> kelas = FirebaseFirestore
  //     .instance
  //     .collection('matkul')
  //     .where(FieldPath.documentId, whereIn: matkul)
  //     .snapshots();

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailKelas(
          post: post,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
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
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kLineDarkColor,
      ),
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(8),
      child: Scrollbar(
        radius: Radius.circular(50),
        child: StreamBuilder<QuerySnapshot>(
          stream: kelas,
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
                    title: TextButton(
                      child: Text(
                        data.docs[index]['nama_kelas'],
                        textAlign: TextAlign.center,
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                          // styling benerin
                        ),
                      ),
                      onPressed: () {
                        navigateToDetail(data.docs[index]);
                        // buat ngecek
                        // print(data.docs[index].id);
                        // // buat ngecek
                        // FirebaseFirestore.instance
                        //     .collection("matkul")
                        //     .get()
                        //     .then((querySnapshot) {
                        //   querySnapshot.docs.forEach((result) {
                        //     print(result.data()['nama_kelas']);
                        //   });
                        // });
                        // Navigator.pushNamed(
                        //   context,
                        //   '/detailKelas',
                        //   arguments: matkulArgumentRoute(
                        //     idMatkul: data.docs[index].id,
                        //   ),
                        // );
                      },
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

  Future<List<Object>> getMatkul() async {
    await FirebaseFirestore.instance
        .collection('jadwal')
        .where('uid_dosen', isEqualTo: widget.myUid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      matkuls = querySnapshot.docs.map((doc) => doc['id_matkul']).toList();
      // querySnapshot.docs.forEach((doc) {
      //   // matkul = matkul.push(doc['id_matkul']);
      //   print(doc['id_matkul']);
      //   // setState(() {
      //   //   matkul = doc['id_matkul'];
      //   // });
      // });
    });
    matkul = matkuls.toSet().toList();
    print(matkul);
    print(myUid);
    return matkul;
  }
}

class matkulArgumentRoute {
  final String idMatkul;
  matkulArgumentRoute({required this.idMatkul});
}
