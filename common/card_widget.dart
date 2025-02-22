// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class CardWidget extends StatelessWidget {
//   final String name;
//   final double price;
//   final Uint8List? imageBytes;
//   final bool isWishlisted;
//   final String productId;
//   final VoidCallback onWishlistToggle;
//   final VoidCallback onAddToCart;
//   const CardWidget(
//       {super.key,
//       required this.name,
//       required this.price,
//       this.imageBytes,
//       required this.isWishlisted,
//       required this.productId,
//       required this.onWishlistToggle,
//       required this.onAddToCart});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(22),
//                     child: imageBytes != null
//                         ? Image.memory(
//                             imageBytes!,
//                             width: double.infinity,
//                             height: double.infinity,
//                             fit: BoxFit.contain,
//                           )
//                         : const Icon(
//                             Icons.image_not_supported_outlined,
//                             size: 50,
//                           )),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, bottom: 5, right: 15),
//                 child: Stack(
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             name,
//                             textAlign: TextAlign.left,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 32, vertical: 5),
//                             margin: const EdgeInsets.only(bottom: 10),
//                             decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     bottomLeft: Radius.circular(20))),
//                             child: Text(
//                               "₹${price.toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     Positioned(
//                         right: 0,
//                         top: 19,
//                         child: GestureDetector(
//                           onTap: onAddToCart,
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: const BoxDecoration(
//                                 color: Colors.black, shape: BoxShape.circle),
//                             child: const Center(
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: IconButton(
//               icon: Icon(
//                 isWishlisted ? Icons.favorite : Icons.favorite_border,
//                 color: isWishlisted ? Colors.red : Colors.grey,
//               ),
//               onPressed: onWishlistToggle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//********************************************************************** */
// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class CardWidget extends StatelessWidget {
//   final String name;
//   final double price;
//   final Uint8List? imageBytes;
//   final bool isWishlisted;
//   final String productId;
//   final VoidCallback onWishlistToggle;
//   final VoidCallback onAddToCart;
//   const CardWidget(
//       {super.key,
//       required this.name,
//       required this.price,
//       this.imageBytes,
//       required this.isWishlisted,
//       required this.productId,
//       required this.onWishlistToggle,
//       required this.onAddToCart});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(22),
//                       child: imageBytes != null
//                           ? Image.memory(
//                               imageBytes!,
//                               width: double.infinity,
//                               height: double.infinity,
//                               fit: BoxFit.contain,
//                             )
//                           : const Icon(
//                               Icons.image_not_supported_outlined,
//                               size: 50,
//                             )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, bottom: 5, right: 15),
//                 child: Stack(
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             name,
//                             textAlign: TextAlign.left,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 32, vertical: 5),
//                             margin: const EdgeInsets.only(bottom: 10),
//                             decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     bottomLeft: Radius.circular(20))),
//                             child: Text(
//                               "₹${price.toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     Positioned(
//                         right: 0,
//                         top: 25,
//                         child: GestureDetector(
//                           onTap: onAddToCart,
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: const BoxDecoration(
//                                 color: Colors.black, shape: BoxShape.circle),
//                             child: const Center(
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: IconButton(
//               icon: Icon(
//                 isWishlisted ? Icons.favorite : Icons.favorite_border,
//                 color: isWishlisted ? Colors.red : Colors.grey,
//               ),
//               onPressed: onWishlistToggle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//**************------------------------------------------ */

import 'dart:typed_data';

import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String name;
  final double price;
  final Uint8List? imageBytes;
  final bool isWishlisted;
  final String productId;
  final VoidCallback onWishlistToggle;
  final VoidCallback onAddToCart;
  const CardWidget(
      {super.key,
      required this.name,
      required this.price,
      this.imageBytes,
      required this.isWishlisted,
      required this.productId,
      required this.onWishlistToggle,
      required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: imageBytes != null
                          ? Image.memory(
                              imageBytes!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.image_not_supported_outlined,
                              size: 50,
                            )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, right: 15),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            name,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 5),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: Text(
                              "₹${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        right: 0,
                        top: 25,
                        child: GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.red : Colors.grey,
              ),
              onPressed: onWishlistToggle,
            ),
          ),
        ],
      ),
    );
  }
}
