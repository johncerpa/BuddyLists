import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/screens/authentication/authentication.dart';
import 'package:movilfinalapp/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return user != null ? Home() : Authentication();
  }
}
