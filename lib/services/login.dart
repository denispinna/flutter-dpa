import 'dart:convert';

import 'package:dpa/models/user.dart';
import 'package:dpa/util/logger.dart';
import 'package:dpa/util/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  static final AuthAPI instance = AuthAPI();
  static const String TAG = "AuthAPI";
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void checkLoggedInUser(OnLoginSuccess onSuccess) async {
    final firebaseUser = await auth.currentUser();
    final user = User.fromFirebaseUser(firebaseUser);
    onSuccess(user);
  }

  void signInWithGoogle(
      BuildContext context, OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };
    final GoogleSignInAccount googleUser =
        await googleSignIn.signIn().catchError(onError);
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication.catchError(onError);

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(TAG, "signed in with google user : ${firebaseUser.displayName}");

    var photoUrl = googleUser.photoUrl.replaceAll("96-c", "1080");
    onLoginSuccess(new User(
        displayName: firebaseUser.displayName,
        imageUrl: photoUrl,
        signInMethod: SignInMethod.Google,
        uid: firebaseUser.uid,
        email: googleUser.email));
  }

  void signOutWithGoogle(OnSuccess onSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing out with google : $exception");
      onSuccess(false);
    };
    await googleSignIn.signOut().catchError(onError);
    Logger.log(TAG, "User signed out from google");
    onSuccess(true);
  }

  void signInWithFacebook(
      BuildContext context, OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing in with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    final FacebookLoginResult result = await facebookSignIn
        .logInWithReadPermissions(['email']).catchError(onError);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);

    final FirebaseUser firebaseUser =
        (await auth.signInWithCredential(credential).catchError(onError)).user;
    Logger.log(
        TAG, "signed in with facebook user : ${firebaseUser.displayName}");

    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
    var profile = json.decode(graphResponse.body);

    var photoUrl = "${firebaseUser.photoUrl}?width=1080&height=1080";
    onLoginSuccess(new User(
        displayName: firebaseUser.displayName,
        imageUrl: photoUrl,
        signInMethod: SignInMethod.Facebook,
        uid: firebaseUser.uid,
        email: profile['email']));
  }

  void signOutWithFacebook(OnSuccess onSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing out with facebook : $exception");
      onSuccess(false);
    };
    await facebookSignIn.logOut().catchError(onError);
    Logger.log(TAG, "User signed out from facebook");
    onSuccess(true);
  }

  void signInWithMail(String email, String password, BuildContext context,
      OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing up with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    AuthResult result = await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError(onError);
    FirebaseUser user = result.user;
    onLoginSuccess(new User(
        displayName: user.displayName,
        imageUrl: user.photoUrl,
        signInMethod: SignInMethod.Facebook,
        uid: user.uid,
        email: email));
  }

  void signOutWithMail(OnSuccess onSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing out with facebook : $exception");
      onSuccess(false);
    };
    await auth.signOut().catchError(onError);
    Logger.log(TAG, "User signed out from facebook");
    onSuccess(true);
  }

  void signUp(String email, String password, BuildContext context,
      OnLoginSuccess onLoginSuccess) async {
    final onError = (exception, stacktrace) {
      Logger.log(TAG, "Error while signing up with facebook : $exception");
      displayMessage("generic_error_message", context, isError: true);
    };

    AuthResult result = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError(onError);
    FirebaseUser user = result.user;
    onLoginSuccess(new User(
        displayName: user.displayName,
        imageUrl: user.photoUrl,
        signInMethod: SignInMethod.Facebook,
        uid: user.uid,
        email: email));
  }

  void signOut(SignInMethod signInMethod, OnSuccess onSuccess) async {
    switch (signInMethod) {
      case SignInMethod.Google:
        signOutWithGoogle(onSuccess);
        break;
      case SignInMethod.Facebook:
        signOutWithFacebook(onSuccess);
        break;
      case SignInMethod.mail:
        break;
    }
    await auth.signOut();
  }
}

typedef OnSuccess = void Function(bool);
typedef OnLoginSuccess = void Function(User);
