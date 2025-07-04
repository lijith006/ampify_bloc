// import 'package:flutter/material.dart';

// class OnBoardScreen1 extends StatefulWidget {
//   const OnBoardScreen1({super.key});

//   @override
//   State<OnBoardScreen1> createState() => _OnBoardScreen1State();
// }

// class _OnBoardScreen1State extends State<OnBoardScreen1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         Image.asset(
//           height: double.infinity,
//           width: double.infinity,
//           'assets/images/onboardscreen_1.jpg',
//           fit: BoxFit.cover,
//         ),

//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 250,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//               color: Colors.white.withOpacity(0.3),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.all(30.0),
//               child: Text(
//                 'Welcome to Ampify! Your ultimate destination for premium audio solutions.',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }
import 'dart:ui';

import 'package:flutter/material.dart';

class OnBoardScreen1 extends StatefulWidget {
  const OnBoardScreen1({super.key});

  @override
  State<OnBoardScreen1> createState() => _OnBoardScreen1State();
}

class _OnBoardScreen1State extends State<OnBoardScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          height: double.infinity,
          width: double.infinity,
          'assets/images/onboardscreen_1.jpg',
          fit: BoxFit.cover,
        ),

        // Dark overlay
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.4),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Welcome to Ampify! Your ultimate destination for premium audio solutions.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
