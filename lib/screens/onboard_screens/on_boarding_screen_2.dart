// import 'package:flutter/material.dart';

// class OnBoardScreen2 extends StatefulWidget {
//   const OnBoardScreen2({super.key});

//   @override
//   State<OnBoardScreen2> createState() => _OnBoardScreen2State();
// }

// class _OnBoardScreen2State extends State<OnBoardScreen2> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         Image.asset(
//           height: double.infinity,
//           width: double.infinity,
//           'assets/images/onboardscreen_2.jpg',
//           fit: BoxFit.cover,
//         ),
//         //overlay
//         Container(
//           height: double.infinity,
//           width: double.infinity,
//           color: Colors.black.withOpacity(0.4),
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
//               color: Colors.white.withOpacity(0.2),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.all(30.0),
//               child: Text(
//                 'Browse, and shop effortlessly. Enjoy secure payments, fast delivery. Your perfect audio companion is just a click away!.',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
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

class OnBoardScreen2 extends StatefulWidget {
  const OnBoardScreen2({super.key});

  @override
  State<OnBoardScreen2> createState() => _OnBoardScreen2State();
}

class _OnBoardScreen2State extends State<OnBoardScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          height: double.infinity,
          width: double.infinity,
          'assets/images/onboardscreen_2.jpg',
          fit: BoxFit.cover,
        ),
        //overlay
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
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
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
                    'Browse, and shop effortlessly. Enjoy secure payments, fast delivery. Your perfect audio companion is just a click away!.',
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
