import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String email;
  String password;
  bool signedIn;
  bool rememberMe;

  AuthProvider() {
    email = '';
    password = '';
    signedIn = false;
    readPrefs();
  }

  //
  setSignedIn(bool remember) {
    rememberMe = remember;
    signedIn = true;

    savePrefs();
    notifyListeners();
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    signedIn = false;
    prefs.setBool('signedIn', false);
    notifyListeners();
  }

  savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('signedIn', signedIn);
    prefs.setBool('rememberMe', rememberMe);
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  // Keep signed in logic
  readPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    bool shouldSignIn = prefs.getBool('signedIn') ?? false;
    String savedEmail = prefs.getString('email') ?? '';
    String savedPassword = prefs.getString('password') ?? '';

    if (shouldSignIn) {
      email = savedEmail;
      password = savedPassword;
      signedIn = shouldSignIn;

      notifyListeners();
    }
  }

  forgetPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }

  // Remember me logic
  rememberUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  forgetUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }

  // changeRemember
  setRememberMe(bool remember) {
    rememberMe = remember;
    rememberPrefs();
    notifyListeners();
    return remember;
  }

  rememberPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
  }
}
