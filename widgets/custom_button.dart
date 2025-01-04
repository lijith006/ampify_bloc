import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final double borderRadius;

  const CustomButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.color = const Color(0xFF323340),
      this.borderRadius = 30.0});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.tealAccent.withOpacity(0.5),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(borderRadius)),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
