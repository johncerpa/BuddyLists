import 'package:flutter/material.dart';
import 'package:movilfinalapp/screens/authentication/signin.dart';
import 'package:movilfinalapp/screens/authentication/signup.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignIn = true;

  void toggleView() => setState(() => showSignIn = !showSignIn);

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toggleView: toggleView)
        : SignUp(toggleView: toggleView);
  }
}
