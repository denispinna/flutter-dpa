import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth.dart';

class FireDb {
  static FireDb instance = FireDb();
  final firestore = Firestore.instance;

  CollectionReference get users => firestore.collection('user');
  CollectionReference get stats => firestore.collection('stat');
  Query get orderedStats => stats
      .where('userEmail', isEqualTo: AuthAPI.instance.user.email)
      .orderBy('date', descending: true);

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

  Future<DocumentReference> postStat(StatItem stat) async {
    final result = await stats.add(stat.toFirestoreData());
    return result;
  }
}
