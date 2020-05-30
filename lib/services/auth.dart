import 'package:firebase_auth/firebase_auth.dart';
import 'package:movilfinalapp/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User userFromFb(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFb);
  }

  Future<User> signIn(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userFromFb(res.user);
    } catch (error) {
      throw error;
    }
  }

  Future<User> signUp(String email, String password) async {
    try {
      AuthResult res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userFromFb(res.user);
    } catch (error) {
      throw error;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
