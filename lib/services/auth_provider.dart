import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String email;
  String password;
  bool signedIn;

  AuthProvider() {
    WidgetsFlutterBinding.ensureInitialized();

    email = '';
    password = '';
    signedIn = false;
    readPrefs();
  }

  setSignedIn() {
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
}
