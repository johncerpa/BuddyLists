import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // Form state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(154, 183, 211, 1),
          elevation: 0.0,
          title: Text('Sign in'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.greenAccent, width: 5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(154, 183, 211, 1),
                            width: 5.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[400], width: 5.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[200], width: 5.0),
                      )),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.greenAccent, width: 5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(154, 183, 211, 1),
                            width: 5.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[400], width: 5.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[200], width: 5.0),
                      )),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (val.length < 6) {
                      return 'Password cannot have less than 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Color.fromRGBO(154, 183, 211, 1),
                  child: Text('Sign in', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        User user = await _auth.signIn(
                            emailController.text, passwordController.text);
                      } catch (error) {
                        final snackbar = SnackBar(
                          content: Text(error.message),
                          backgroundColor: Colors.red,
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                      }
                    }
                  },
                ),
                FlatButton(
                    onPressed: () => widget.toggleView(),
                    child: Text('Sign up'))
              ]),
            )));
  }
}
