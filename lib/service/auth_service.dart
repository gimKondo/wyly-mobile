import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get Firebase user if already sign in
  Future<FirebaseUser> getFirebaseUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  /// Sign up new user by [email] address and [password]
  /// if fail to sign up, throw PlatformException
  Future<FirebaseUser> signUpByEmailAndPass(
    String email,
    String password,
  ) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = authResult.user;
      print("signed up by ${user.email}");
      return user;
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
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = authResult.user;
      print("signed in by ${user.email}");
      return user;
    } catch (e) {
      print("fail to sign in. err:[$e]");
      rethrow;
    }
  }

  /// sign out
  Future<void> singOut() async {
    await _auth.signOut();
  }
}
