//**************------------------------------------------ */

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
//********************************************** */
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CardWidget extends StatelessWidget {
//   final String name;
//   final double price;
//   final Uint8List? imageBytes;
//   final bool isWishlisted;
//   final String productId;
//   final VoidCallback onWishlistToggle;
//   final VoidCallback onAddToCart;
//   final int cartCount;
//   const CardWidget(
//       {super.key,
//       required this.name,
//       required this.price,
//       this.imageBytes,
//       required this.isWishlisted,
//       required this.productId,
//       required this.onWishlistToggle,
//       required this.onAddToCart,
//       required this.cartCount});

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
//                       right: 0,
//                       top: 25,
//                       child: BlocBuilder<CartBloc, CartState>(
//                         builder: (context, state) {
//                           if (state is CartLoaded) {
//                             final cartCount = state.cartItems
//                                 .where((item) => item.productId == productId)
//                                 .fold(0, (sum, item) => sum + item.quantity);
//                             return cartCount > 0
//                                 ? _buildCartCountWidget(cartCount)
//                                 : _buildAddToCartButton();
//                           } else {
//                             return _buildAddToCartButton();
//                           }
//                         },
//                       ),
//                       //  cartCount > 0
//                       //     ? _buildCartCountWidget()
//                       //     : _buildAddToCartButton(),
//                     ),
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

//   // Widget to show the add to cart button
//   Widget _buildAddToCartButton() {
//     return GestureDetector(
//       onTap: onAddToCart,
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration:
//             const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//         child: const Center(
//           child: Icon(
//             Icons.add,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget to show the product count in the cart
//   Widget _buildCartCountWidget(int cartCount) {
//     return Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//           color: Colors.black, borderRadius: BorderRadius.circular(15)),
//       child: Center(
//         child: Text(
//           cartCount.toString(),
//           style: const TextStyle(
//               color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
//------------------------today------------------------------

import 'dart:typed_data';

import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardWidget extends StatefulWidget {
  final String name;
  final double price;
  final Uint8List? imageBytes;
  final bool isWishlisted;
  final String productId;
  final VoidCallback onWishlistToggle;
  final VoidCallback onAddToCart;
  final int cartCount;

  const CardWidget(
      {super.key,
      required this.name,
      required this.price,
      this.imageBytes,
      required this.isWishlisted,
      required this.productId,
      required this.onWishlistToggle,
      required this.onAddToCart,
      required this.cartCount});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showTick = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showTick = false;
            });
            print("Animation completed, hiding tick");
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    setState(() {
      _showTick = true;
    });
    _animationController.reset();
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onAddToCart();
    });
    print("Add to cart clicked, showing tick animation");
  }

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
                      child: widget.imageBytes != null
                          ? Image.memory(
                              widget.imageBytes!,
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
                            widget.name,
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
                              "₹${widget.price.toStringAsFixed(2)}",
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
                      child: BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          if (state is CartLoaded) {
                            final cartCount = state.cartItems
                                .where((item) =>
                                    item.productId == widget.productId)
                                .fold(0, (sum, item) => sum + item.quantity);
                            print(
                                "ProductId: ${widget.productId}, Cart count: $cartCount, Show tick: $_showTick");
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              child: _showTick
                                  ? _buildTickAnimation()
                                  : (cartCount > 0
                                      ? _buildCartCountWidget(cartCount)
                                      : _buildAddToCartButton()),
                            );
                          } else {
                            print(
                                "Cart state is not loaded: ${state.runtimeType}");
                            return _buildAddToCartButton();
                          }
                        },
                      ),
                    ),
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
                widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: widget.isWishlisted ? Colors.red : Colors.grey,
              ),
              onPressed: widget.onWishlistToggle,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show the add to cart button
  Widget _buildAddToCartButton() {
    return GestureDetector(
      onTap: _handleAddToCart,
      child: Container(
        width: 30,
        height: 30,
        decoration:
            const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // Widget to show the product count in the cart
  Widget _buildCartCountWidget(int cartCount) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(
          cartCount.toString(),
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget to show the tick animation
  Widget _buildTickAnimation() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}
