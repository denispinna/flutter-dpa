import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class FireDbComponent {
  static FireDbComponent instance;
  Firestore firestore;

  CollectionReference get users => firestore.collection('user');
  CollectionReference get stats => firestore.collection('stat');

  static Future<FireDbComponent> init() async{
    instance = FireDbComponent();
    await instance.setupApp();
    return instance;
  }

  Future<Firestore> setupApp() async {
    final googleAppID = Platform.isIOS
        ? '1:24536428262:ios:626316e8291989d2fc5527'
        : '1:24536428262:android:4bc81092f3547f7ffc5527';
    final FirebaseApp app = await FirebaseApp.configure(
        name: 'test',
        options: FirebaseOptions(
          googleAppID: googleAppID,
          apiKey: 'AIzaSyDqCyD01qCyz4NH7zmuh7XTVHjrNyDVJhk',
          projectID: 'dontplayalone-251610',
        ));
    this.firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
    return firestore;
  }
  
  Future<User> findUser(String email) async {
    final query = await users.where('email', isEqualTo: email).limit(1).getDocuments();
    if(query.documents.isEmpty) {
      return null;
    }
    final data = query.documents[0].data;
    return User.fromFirestoreData(data);
  }

  Future saveNewUser(User user) async {
    final existingUser = await findUser(user.email);
    if(existingUser != null)
      return;
    await users.add(user.toFirestoreData());
  }
}
