import 'package:ampify_bloc/screens/cart/cart.dart';
import 'package:ampify_bloc/screens/home/home_screen.dart';
import 'package:ampify_bloc/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int selectedIndex = 2;
  void onItemTapped(int index) {
    if (index != selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (index == 0) return const HomeScreen();
          if (index == 1) return const MyCart();
          return const MyCart();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Text('Content'),
      bottomNavigationBar:
          CustomBottomNavBar(currentIndex: selectedIndex, onTap: onItemTapped),
    );
  }
}
