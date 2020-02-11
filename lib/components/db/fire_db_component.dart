import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/user.dart';

class FireDb {
  static FireDb instance = FireDb();
  final _firestore = Firestore.instance;

  FireDb() {
    _firestore.settings(persistenceEnabled: true);
  }

  CollectionReference get users => _firestore.collection('user');

  CollectionReference get stats => _firestore.collection('stat');

  CollectionReference get statsItems => _firestore.collection('stat_item');
}
