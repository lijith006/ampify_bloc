import 'dart:async';
import 'package:ampify_bloc/screens/on_boarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  bool showText = false;

  @override
  void initState() {
    super.initState();

    // Logo scale animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        showText = true;
      });
    });

    // Navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreens()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                'assets/logo/ampifylogo-circle.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),

            // Ampify text appears with animation
            if (showText)
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Ampify',
                    textStyle: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
              ),
          ],
        ),
      ),
    );
  }
}
