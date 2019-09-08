
class User {
  User({this.uid, this.displayName, this.photoUrl, this.email, this.signInMethod});

  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final SignInMethod signInMethod;
}

enum SignInMethod { Google, Facebook, mail }
