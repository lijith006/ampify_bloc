import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double moveUp;

  const LoadingWidget({
    super.key,
    this.width = 300,
    this.height = 300,
    this.moveUp = 0, // Default, no movement
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -moveUp), // Moves animation up if needed
      child: Lottie.asset(
        'assets/animations/loading.json',
        width: width,
        height: height,
      ),
    );
  }
}
