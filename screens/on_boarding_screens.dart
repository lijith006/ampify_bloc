import 'package:ampify_bloc/screens/onboardScreens/on_boarding_screen_1.dart';
import 'package:ampify_bloc/screens/onboardScreens/on_boarding_screen_2.dart';
import 'package:ampify_bloc/screens/onboardScreens/on_boarding_screen_3.dart';
import 'package:ampify_bloc/widgets/wrapper.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({super.key});

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final PageController _controller = PageController();
  //to check if we are on last page
  bool onLastPage = false;

//onboard with wrp
  Future<void> completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              OnBoardScreen1(),
              OnBoardScreen2(),
              OnBoardScreen3()
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: const Color.fromARGB(255, 173, 177, 169),
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        _controller.jumpToPage(2);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text(
                          'skip',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  //indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 13.0,
                      dotWidth: 13.0,
                    ),
                    onDotClicked: (index) {
                      _controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  //next or done option

                  onLastPage
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor:
                                const Color.fromARGB(255, 173, 177, 169),
                            borderRadius: BorderRadius.circular(50),
                            onTap: () => completeOnboarding(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: const Text(
                                'done',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor:
                                const Color.fromARGB(255, 173, 177, 169),
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: const Text(
                                'next',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                ],
              ))
        ],
      ),
      backgroundColor: Colors.green,
    );
  }
}
