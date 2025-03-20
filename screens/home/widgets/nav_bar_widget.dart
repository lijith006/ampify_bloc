// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:ampify_bloc/common/app_colors.dart';

// class BottomNavigation extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTabChange;

//   const BottomNavigation({
//     Key? key,
//     required this.selectedIndex,
//     required this.onTabChange,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.backgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: GNav(
//           gap: 8,
//           selectedIndex: selectedIndex,
//           onTabChange: onTabChange,
//           tabs: const [
//             GButton(
//               icon: Icons.home,
//               text: 'Home',
//             ),
//             GButton(
//               icon: Icons.favorite,
//               text: 'Wishlist',
//             ),
//             GButton(
//               icon: Icons.shopping_cart,
//               text: 'My cart',
//             ),
//             GButton(
//               icon: Icons.person,
//               text: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
