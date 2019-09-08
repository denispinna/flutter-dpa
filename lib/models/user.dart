import 'package:firebase_auth/firebase_auth.dart';

class User {
  User(
      {this.uid,
      this.displayName,
      this.imageUrl,
      this.email,
      this.signInMethod});

  static User fromFirebaseUser(FirebaseUser user) {
    var uid = user.uid;
    var displayName = user.displayName;
    var imageUrl = user.photoUrl;
    var email = user.email;
    var signInMethod = SignInMethod.mail;

    for (var profile in user.providerData) {
      if(profile.providerId.contains("google")) {
        signInMethod = SignInMethod.Google;
      } else if (profile.providerId.contains("facebook")) {
        signInMethod = SignInMethod.Facebook;
      }
      if(displayName == null) {
        displayName =profile.displayName;
      }
      if(email == null) {
        email =profile.email;
      }
      if(imageUrl == null) {
        imageUrl =profile.photoUrl;
      }
    }
    switch (signInMethod) {
      case SignInMethod.Google:
        imageUrl = imageUrl.replaceAll("96-c", "1080");
        break;
      case SignInMethod.Facebook:
        imageUrl = "$imageUrl?width=1080&height=1080";
        break;
      case SignInMethod.mail:
        break;
    }
    return User(
      uid: uid,
      displayName: displayName,
      imageUrl: imageUrl,
      email: email,
      signInMethod: signInMethod
    );
  }

  final String uid;
  final String displayName;
  final String imageUrl;
  final String email;
  final SignInMethod signInMethod;
}

enum SignInMethod { Google, Facebook, mail }
