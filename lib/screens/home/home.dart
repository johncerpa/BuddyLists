import 'package:flutter/material.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/shared/constants.dart';

import '../../locator.dart';

class Home extends StatelessWidget {
  final AuthService auth = locator<AuthService>();
  final AuthProvider ap = locator<AuthProvider>();

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
              await auth.signOut();
              ap.logout();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white, size: 24.0),
          )
        ],
      ),
    );
  }
}
