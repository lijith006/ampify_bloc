import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class CachedCartImage extends StatefulWidget {
  final String base64Image;

  const CachedCartImage({super.key, required this.base64Image});

  @override
  State<CachedCartImage> createState() => _CachedCartImageState();
}

class _CachedCartImageState extends State<CachedCartImage> {
  late Uint8List imageBytes;

  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.base64Image);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        imageBytes,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}
