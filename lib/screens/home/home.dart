import 'package:flutter/material.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/shared/constants.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0.0,
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white, size: 24.0),
          )
        ],
      ),
    );
  }
}
