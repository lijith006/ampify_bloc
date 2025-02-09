// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTap;

//   const CustomBottomNavBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: CurvedNavigationBar(
//         index: selectedIndex,
//         height: 65.0,
//         backgroundColor: Colors.transparent,
//         color: Colors.white,
//         buttonBackgroundColor: Colors.blue.shade100,
//         animationDuration: const Duration(milliseconds: 400),
//         animationCurve: Curves.easeOutQuad,
//         items: [
//           _buildNavItem(Icons.home_outlined, Icons.home, 0),
//           _buildNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 1),
//           _buildNavItem(Icons.person_outline, Icons.person, 2),
//         ],
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, int index) {
//     return Icon(
//       selectedIndex == index ? filledIcon : outlinedIcon,
//       size: 30,
//       color: selectedIndex == index ? Colors.blue : Colors.grey,
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomNavClipper(),
      child: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;

    path.lineTo(0, height);
    path.quadraticBezierTo(width * 0.25, height - 40, width * 0.5, height - 20);
    path.quadraticBezierTo(width * 0.75, height, width, height - 20);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
