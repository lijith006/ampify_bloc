import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
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

  static TextStyle screenHeading() {
    return const TextStyle(
        fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white);
  }
}
