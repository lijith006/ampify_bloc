// import 'package:flutter/material.dart';

// class SearchField extends StatelessWidget {
//   final TextEditingController controller;
//   final Function() onSearch;

//   const SearchField({
//     Key? key,
//     required this.controller,
//     required this.onSearch,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage('assets/images/ampifylogo.png'),
//           ),
//         ),
//         Expanded(
//           child: TextField(
//             controller: controller,
//             style: const TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               hintText: 'Search products...',
//               hintStyle: const TextStyle(color: Colors.grey),
//               border: InputBorder.none,
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.search, color: Colors.black),
//                 onPressed: onSearch,
//               ),
//             ),
//             onSubmitted: (_) => onSearch(),
//           ),
//         ),
//       ],
//     );
//   }
// }
