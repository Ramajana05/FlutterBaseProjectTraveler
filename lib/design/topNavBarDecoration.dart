import 'package:flutter/material.dart';
import '../color/appColors.dart';

class topNavBarDecoration {
  static const Color startGradientColor =
      Color.fromARGB(255, 250, 22, 132); 
  static const Color endGradientColor =
      Color.fromARGB(255, 157, 0, 255); 

  static BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      boxShadow: [],
    );
  }

  static TextStyle getTitleTextStyle() {
    return TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
  }

  static AnimatedContainer getAnimatedBoxDecoration() {
    return AnimatedContainer(
      duration: Duration(seconds: 2), 
      decoration: BoxDecoration(),
    );
  }
}
