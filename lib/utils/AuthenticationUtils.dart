import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

FirebaseUser firebaseUser;
final googleSignIn = new GoogleSignIn(scopes: ['email']);
final firebaseAuth = FirebaseAuth.instance;

// ignore: missing_return
Future<FirebaseUser> ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();
  if (user == null) {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  if (await firebaseAuth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    FirebaseUser firebaseUser = await firebaseAuth
        .signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    )
        .catchError((error) {
      return null;
    });
    return firebaseUser;
  }else {
    return await firebaseAuth.currentUser();
  }
}
