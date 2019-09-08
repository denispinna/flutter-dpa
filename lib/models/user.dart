

import 'package:firebase_auth/firebase_auth.dart';

class User {
  User(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerDetails);

  static User fromFirebaseUser(FirebaseUser user) {
    return User(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        new ProviderDetails(
            user.providerId,
            user.uid,
            user.displayName,
            user.photoUrl,
            user.email));
  }
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
  final ProviderDetails providerDetails;
}

class ProviderDetails {
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  ProviderDetails(
      this.providerId, this.uid, this.displayName, this.photoUrl, this.email);
}