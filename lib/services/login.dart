import 'package:dpa/models/user.dart';
import 'package:dpa/util/logger.dart';
import 'package:dpa/util/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthAPI {
  static const String TAG = "AuthAPI";
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle(BuildContext context) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context);
    };
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(TAG, "signed in with google user : ${firebaseUser.displayName}");
    return User.fromFirebaseUser(firebaseUser);
  }

  void signOutWithGoogle() async {
    await googleSignIn.signOut();
    Logger.log(TAG, "User signed out from google");
  }

  Future<User> signInWithFacebook(BuildContext context) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context);
    };

    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(
        TAG, "signed in with facebook user : ${firebaseUser.displayName}");
    return User.fromFirebaseUser(firebaseUser);
  }

  void signOutWithFacebook() async {
    await facebookSignIn.logOut();
    Logger.log(TAG, "User signed out from facebook");
  }
}
