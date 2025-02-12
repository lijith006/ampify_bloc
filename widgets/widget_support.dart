import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      color: Color(0xFF333333),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldCardTitle() {
    return const TextStyle(
      color: Color(0xFF333333),
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle lightTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle whitelightTextFieldStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    );
  }

  static TextStyle screenHeading() {
    return const TextStyle(
        fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white);
  }

  static TextStyle screenHeadingBlack() {
    return const TextStyle(
        fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black);
  }
}
