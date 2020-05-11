import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  factory AuthService() {
    if (_authService == null) {
      _authService = AuthService._internal();
    }
    return _authService;
  }
  AuthService._internal();
  static AuthService _authService;

  // initialize on signing in/up
  FirebaseUser _user;

  FirebaseUser get user => _user;

  /// initialize Firebase user if already sign in
  Future<FirebaseUser> initializeFirebaseUser() async {
    _user = await FirebaseAuth.instance.currentUser();
    return _user;
  }

  /// Sign in/up by Google Account
  Future<FirebaseUser> signInByGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleCurrentUser;
      // var googleCurrentUser = googleSignIn.currentUser;
      // if (googleCurrentUser == null) {
      //   googleCurrentUser = await googleSignIn.signInSilently();
      // }
      if (googleCurrentUser == null) {
        googleCurrentUser = await googleSignIn.signIn();
      }
      if (googleCurrentUser == null) {
        return null;
      }

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      debugPrint('signed in ${_user.displayName}');

      return _user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Sign up new user by [email] address and [password]
  /// if fail to sign up, throw PlatformException
  Future<FirebaseUser> signUpByEmailAndPass(
    String email,
    String password,
  ) async {
    try {
      final authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = authResult.user;
      print("signed up by ${_user.email}");
      return _user;
    } catch (e) {
      print("fail to sign up. err:[$e]");
      rethrow;
    }
  }

  /// Sign in by [email] address and [password]
  /// if fail to login, throw PlatformException
  Future<FirebaseUser> signInByEmailAndPass(
    String email,
    String password,
  ) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = authResult.user;
      print("signed in by ${_user.email}");
      return _user;
    } catch (e) {
      print("fail to sign in. err:[$e]");
      rethrow;
    }
  }

  /// sign out
  Future<void> singOut() async {
    await FirebaseAuth.instance.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
