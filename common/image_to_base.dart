import 'dart:convert';
import 'package:flutter/material.dart';

class ImageUtils {
  // Convert Base64 string to an Image widget
  static Widget base64ToImage(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }
}
