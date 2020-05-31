import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/signup_vm.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Form state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpViewModel>(
        builder: (context, model, child) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://sabinereinhart.com/universal/packages/slides/lib/layouts/cover-page/landing-full-center-01/img/gallery/0.jpg?format=100w'),
              )),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  key: _scaffoldKey,
                  appBar: AppBar(
                    backgroundColor: appColor,
                    elevation: 0.0,
                    title:
                        Text('Sign up', style: TextStyle(color: Colors.black)),
                  ),
                  body: Container(
                      margin: EdgeInsets.only(top: 80.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          emailField(),
                          SizedBox(
                            height: 20.0,
                          ),
                          passwordField(),
                          SizedBox(height: 20.0),
                          signUpButton(model),
                          RaisedButton(
                              onPressed: () => widget.toggleView(),
                              child: Text('Sign in')),
                          model.state == ViewState.Busy ? Loading() : SizedBox()
                        ]),
                      ))),
            ));
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
          hintText: 'Email',
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
          return 'Email cannot be empty';
        }
        return null;
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

  Widget signUpButton(SignUpViewModel model) {
    return RaisedButton(
      color: appColor,
      child: Text('Sign up', style: TextStyle(color: Colors.black)),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          try {
            User user = await model.signUp(
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
    );
  }
}
