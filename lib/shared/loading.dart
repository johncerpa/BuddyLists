import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: SpinKitChasingDots(color: appColor, size: 50.0),
    ));
  }
}
