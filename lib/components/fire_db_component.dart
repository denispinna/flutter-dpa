import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth_services.dart';

class FireDb {
  static const int CACHE_SIZE = 10737418240;
  static FireDb instance = FireDb();
  final _firestore = Firestore.instance;

  FireDb() {
    _firestore.settings(persistenceEnabled: true, cacheSizeBytes: CACHE_SIZE);
  }

  CollectionReference get users => _firestore.collection('user');

  CollectionReference get stats => _firestore.collection('stat');

  Future<User> findUser(String email) async {
    final query =
        await users.where('email', isEqualTo: email).limit(1).getDocuments();
    if (query.documents.isEmpty) {
      return null;
    }
    final data = query.documents[0].data;
    return User.fromFirestoreData(data);
  }

  Future saveNewUser(User user) async {
    final existingUser = await findUser(user.email);
    if (existingUser != null) return;
    await users.add(user.toFirestoreData());
  }

  Future<DocumentReference> postStat(DateStatEntry stat) async {
    final result = await stats.add(stat.toFirestoreData());
    return result;
  }
}
