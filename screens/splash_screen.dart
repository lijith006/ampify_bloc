// import 'dart:async';

// import 'package:ampify_bloc/screens/on_boarding_screens.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const OnBoardingScreens()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Row(
//         children: [
//           Lottie.asset('assets/speaker1.json',
//               width: 200, height: 250, fit: BoxFit.cover),
//           AnimatedTextKit(
//             animatedTexts: [
//               TyperAnimatedText(
//                 'Ampify',
//                 textStyle:
//                     const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                 speed: const Duration(milliseconds: 100),
//               ),
//             ],
//             totalRepeatCount: 1,
//             repeatForever: false,
//           ),
//         ],
//       ),
//     ));
//   }
// }
//-------------------------------------------APR 9

import 'dart:async';

import 'package:ampify_bloc/screens/on_boarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreens()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              const Color.fromARGB(255, 26, 11, 46)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/speaker1.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                repeat: true,
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Ampify',
                    textStyle: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                totalRepeatCount: 1,
                repeatForever: false,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Music Experience Amplified',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
