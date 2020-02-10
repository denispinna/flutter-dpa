import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/util/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthAPI {
  static final AuthAPI instance = AuthAPI();
  static const String TAG = "AuthAPI";
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  Future<User> loadCurrentUser() async {
    final firebaseUser = await auth.currentUser();
    if (firebaseUser == null) {
      return null;
    }
    user = User.fromFirebaseUser(firebaseUser);
    return user;
  }

  Future signInWithGoogle(
      BuildContext context, OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };
    final GoogleSignInAccount googleUser =
        await googleSignIn.signIn().catchError(onError);

    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication.catchError(onError);

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(TAG, "signed in with google user : ${firebaseUser.displayName}");
    saveUserInFirestore(firebaseUser, onLoginSuccess);
  }

  Future signOutWithGoogle() async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing out with google : $exception");
    };
    await googleSignIn.signOut().catchError(onError);
    Logger.log(TAG, "User signed out from google");
  }

  Future signInWithFacebook(
      BuildContext context, OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    final FacebookLoginResult result = await facebookSignIn
        .logIn(['email', 'public_profile']).catchError(onError);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(
        TAG, "signed in with facebook user : ${firebaseUser.displayName}");
    saveUserInFirestore(firebaseUser, onLoginSuccess);
  }

  Future signOutWithFacebook() async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing out with facebook : $exception");
    };
    await facebookSignIn.logOut().catchError(onError);
    Logger.log(TAG, "User signed out from facebook");
  }

  Future signInWithMail(String email, String password, BuildContext context,
      OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing up with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    AuthResult result = await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError(onError);
    FirebaseUser firebaseUser = result.user;
    saveUserInFirestore(firebaseUser, onLoginSuccess);
  }

  Future signUp(String email, String password, BuildContext context,
      OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing up with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    AuthResult result = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError(onError);
    FirebaseUser firebaseUser = result.user;
    saveUserInFirestore(firebaseUser, onLoginSuccess);
  }

  Future saveUserInFirestore(
      FirebaseUser firebaseUser, OnLoginSuccess onLoginSuccess) async {
    user = User.fromFirebaseUser(firebaseUser);
    await FireDb.instance.saveNewUser(user);
    onLoginSuccess(user);
  }

  Future signOut(SignInMethod signInMethod, OnSuccess onSuccess) async {
    switch (signInMethod) {
      case SignInMethod.Google:
        signOutWithGoogle();
        break;
      case SignInMethod.Facebook:
        signOutWithFacebook();
        break;
      case SignInMethod.mail:
        break;
    }
    await auth.signOut();
    onSuccess();
  }
}

typedef OnSuccess = void Function();
typedef OnLoginSuccess = void Function(User);
