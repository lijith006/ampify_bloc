import 'dart:async';

import 'package:ampify_bloc/screens/on_boarding_screens.dart';
// import 'package:ampify_bloc/widgets/wrapper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //navigateToNextScreen();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreens()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: SpinKitWave(
                color: Color.fromARGB(255, 67, 25, 165),
                size: 35.0,
              ),
              //Image.asset('assets/images/ampify_logo.png')
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Text(
              'Ampify',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
