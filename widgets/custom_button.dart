import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? prefixIcon;
  final String label;
  final VoidCallback onTap;
  //final Color color;
  final double borderRadius;

  const CustomButton(
      {super.key,
      required this.label,
      required this.onTap,
      // this.color = const Color(0xFF323340),

      this.borderRadius = 30.0,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.tealAccent.withOpacity(0.5),
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 156, 91, 226),
                  Color.fromARGB(255, 17, 89, 214)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // color: color,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3)),
              ]),
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
