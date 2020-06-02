import 'package:firebase_auth/firebase_auth.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import '../locator.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final listsService = locator<ListsService>();
  User user;

  User userFromFb(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userFromFb(res.user);
    } catch (error) {
      throw error;
    }
  }

  Future<User> signUp(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = await _auth.currentUser();

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = name;

      user.updateProfile(updateInfo);

      return userFromFb(user);
    } catch (error) {
      throw error;
    }
  }

  Future signOut() async {
    try {
      listsService.clearInformation();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
