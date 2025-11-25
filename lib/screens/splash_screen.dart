import 'dart:async';
import 'package:ampify_bloc/screens/onboard_screens/on_boarding_screens.dart';
import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

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
                width: 300,
                height: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'dart:async';
// import 'package:ampify_bloc/screens/onboard_screens/on_boarding_screens.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// // import 'package:animated_text_kit/animated_text_kit.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late Animation<double> _logoAnimation;

//   bool showText = false;

//   @override
//   void initState() {
//     super.initState();
//     // requestLocationPermission();
//     requestLocationPermission().catchError((e) {
//       debugPrint('Location permission error (ignoring): $e');
//     });

//     // Logo scale animation
//     _logoController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _logoAnimation =
//         CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);

//     _logoController.forward();

//     Future.delayed(const Duration(milliseconds: 1200), () {
//       setState(() {
//         showText = true;
//       });
//     });

//     // Navigate
//     Timer(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const OnBoardingScreens()),
//         );
//       }

//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => const OnBoardingScreens()),
//       // );
//     });
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ScaleTransition(
//               scale: _logoAnimation,
//               child: Image.asset(
//                 'assets/logo/ampifylogo-circle.png',
//                 width: 300,
//                 height: 250,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Future<void> requestLocationPermission() async {
// //   LocationPermission permission = await Geolocator.checkPermission();
// //   if (permission == LocationPermission.denied) {
// //     permission = await Geolocator.requestPermission();
// //     if (permission == LocationPermission.denied) {
// //       debugPrint("Location permissions are denied");
// //     }
// //   }
// //   if (permission == LocationPermission.deniedForever) {
// //     debugPrint(
// //         "Location permissions are permanently denied, enable them from settings.");
// //   }
// // }
// Future<void> requestLocationPermission() async {
//   try {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         debugPrint("Location permissions are denied");
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       debugPrint(
//           "Location permissions are permanently denied, enable them from settings.");
//     }
//   } catch (e) {
//     debugPrint("Error requesting location permission: $e");
//     // Don't rethrow - allow app to continue
//   }
// }
