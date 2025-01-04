import 'package:flutter/material.dart';

class OnBoardScreen3 extends StatefulWidget {
  const OnBoardScreen3({super.key});

  @override
  State<OnBoardScreen3> createState() => _OnBoardScreen3State();
}

class _OnBoardScreen3State extends State<OnBoardScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          height: double.infinity,
          width: double.infinity,
          'assets/images/onboardscreen_3.jpg',
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white.withOpacity(0.3),
            ),
            child: const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Explore an extensive range of high-quality speakers, home theaters, airdopes, subwoofers, and more from top brands like JBL, Bose, Boat,Yamaha, and Sony. Immerse yourself in sound like never before.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
