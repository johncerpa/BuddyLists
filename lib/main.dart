import 'package:flutter/material.dart';
import 'package:movilfinalapp/locator.dart';
import 'package:movilfinalapp/screens/authentication/authentication.dart';
import 'package:movilfinalapp/screens/central/central.dart';
import 'package:movilfinalapp/screens/home/home.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthProvider _authProvider = locator<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _authProvider,
      child: MaterialApp(
        title: 'Shopping app',
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return authProvider.signedIn ? Central() : Authentication();
    });
  }
}
