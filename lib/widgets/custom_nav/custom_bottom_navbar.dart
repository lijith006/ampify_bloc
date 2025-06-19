import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'nav_cubit.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, selectedIndex) {
        return GNav(
          gap: 8,
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            HapticFeedback.heavyImpact();
            context.read<NavCubit>().updateIndex(index);
          },
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.favorite, text: 'Wishlist'),
            GButton(icon: Icons.shopping_cart, text: 'My cart'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        );
      },
    );
  }
}
