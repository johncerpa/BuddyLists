import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/locator.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/signin_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Form state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<SignInViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          elevation: 0.0,
          title: Text('Sign in'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                emailField(),
                SizedBox(
                  height: 20.0,
                ),
                passwordField(),
                SizedBox(height: 20.0),
                rememberMeCheckbox(),
                SizedBox(
                  height: 20.0,
                ),
                signInButton(model),
                FlatButton(
                    onPressed: () => widget.toggleView(),
                    child: Text('Sign up')),
                model.state == ViewState.Busy ? Loading() : SizedBox()
              ]),
            )),
      ),
    );
  }

  Widget emailField() {
    return FutureBuilder(
      future: getEmailAndPassword(),
      builder: (BuildContext context, AsyncSnapshot s) {
        if (s.hasData) {
          if (s.data.email.length > 0 && s.data.rememberMe) {
            emailController.text = s.data.email;
            passwordController.text = s.data.password;
          }
        } else {
          emailController.text = "";
          passwordController.text = "";
        }

        return TextFormField(
          controller: emailController,
          decoration: InputDecoration(
              hintText: 'Email',
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.greenAccent, width: 5.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appColor, width: 5.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[400], width: 5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[200], width: 5.0),
              )),
          validator: (val) {
            if (val.isEmpty) {
              return 'Email cannot be empty';
            }
            return null;
          },
        );
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 5.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor, width: 5.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[400], width: 5.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[200], width: 5.0),
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
    );
  }

  rememberMeCheckbox() {
    return CheckboxListTile(
        title: Text('Remember me'),
        value: rememberMe,
        onChanged: (bool value) {
          AuthProvider ap = locator<AuthProvider>();
          setState(() {
            rememberMe = ap.setRememberMe(value);
          });
        },
        secondary: const Icon(Icons.memory, color: Colors.grey));
  }

  Widget signInButton(SignInViewModel model) {
    return RaisedButton(
      color: appColor,
      child: Text('Sign in', style: TextStyle(color: Colors.white)),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          try {
            User user = await model.signIn(
                emailController.text, passwordController.text, rememberMe);
          } catch (error) {
            final snackbar = SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackbar);
          }
        }
      },
    );
  }

  getEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? "";
    String password = prefs.getString("password") ?? "";
    bool isRemembered = prefs.getBool("rememberMe") ?? false;

    setState(() {
      rememberMe = isRemembered;
    });
    return EmailPassword(email, password, isRemembered);
  }
}

class EmailPassword {
  String email, password;
  bool rememberMe;
  EmailPassword(this.email, this.password, this.rememberMe);
}
