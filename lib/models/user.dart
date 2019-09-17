import 'package:dpa/components/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  static const TAG = "User";
  final String displayName;
  final String imageUrl;
  final String email;
  final SignInMethod signInMethod;

  User({this.displayName, this.imageUrl, this.email, this.signInMethod});

  static User fromFirebaseUser(FirebaseUser user) {
    try {
      var displayName = user.displayName;
      var imageUrl = user.photoUrl;
      var email = user.email;
      var signInMethod = SignInMethod.mail;

      for (var profile in user.providerData) {
        if (profile.providerId.contains("google")) {
          signInMethod = SignInMethod.Google;
        } else if (profile.providerId.contains("facebook")) {
          signInMethod = SignInMethod.Facebook;
        }
        if (displayName == null) {
          displayName = profile.displayName;
        }
        if (email == null) {
          email = profile.email;
        }
        if (imageUrl == null) {
          imageUrl = profile.photoUrl;
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
          displayName: displayName,
          imageUrl: imageUrl,
          email: email,
          signInMethod: signInMethod);
    } catch (exc) {
      Logger.logError(TAG, "Error while parsing firebase user", exc);
      return null;
    }
  }

  static User fromFirestoreData(Map<String, dynamic> data) {
    final email = data['email'];
    final imageUrl = data['imageUrl'];

    return User(email: email, imageUrl: imageUrl);
  }

  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      'email': email,
      'imageUrl': imageUrl
    };
  }
}

enum SignInMethod { Google, Facebook, mail }
