import 'package:ampify_bloc/screens/home/home_screen.dart';
import 'package:ampify_bloc/screens/profile/profile.dart';
import 'package:ampify_bloc/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int selectedIndex = 1;
  void onItemTapped(int index) {
    if (index != selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (index == 0) return const HomeScreen();
          if (index == 2) return const MyProfile();
          return const MyCart();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Text('data '),
      bottomNavigationBar:
          CustomBottomNavBar(currentIndex: selectedIndex, onTap: onItemTapped),
    );
  }
}
