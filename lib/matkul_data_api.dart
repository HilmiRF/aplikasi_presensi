import 'package:cloud_firestore/cloud_firestore.dart';
import './model/detail_kelas.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('matkul');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
}
