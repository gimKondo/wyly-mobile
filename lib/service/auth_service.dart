import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login by [email] address and [password]
  Future<FirebaseUser> loginByEmailAndPass(
    String email,
    String password,
  ) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = authResult.user;
      print("signed in " + user.displayName);
      return user;
    } catch (e) {
      print("fail to login. err:[$e]");
      return null;
    }
  }
}
