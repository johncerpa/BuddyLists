import 'package:flutter/material.dart';
import 'package:movilfinalapp/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(123, 146, 168, 1),
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
