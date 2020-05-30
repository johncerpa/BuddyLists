import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/screens/wrapper.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(title: 'Firebase Auth Demo', home: Wrapper()));
  }
}
