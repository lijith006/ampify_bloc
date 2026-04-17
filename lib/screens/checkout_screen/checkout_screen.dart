// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
// import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
// import 'package:ampify_bloc/screens/payment/bloc/payment_bloc.dart' as payment;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../common/app_colors.dart';
// import '../checkout_screen/bloc/checkout_bloc.dart';
// import '../checkout_screen/bloc/checkout_event.dart';
// import '../checkout_screen/bloc/checkout_state.dart';
// import '../checkout_screen/select_address_screen.dart';
// import '../cart/cart_model.dart';
// import '../../widgets/custom_orange_button.dart';

// class CheckoutScreen extends StatelessWidget {
//   final List<CartItem> products;

//   const CheckoutScreen({super.key, required this.products});

//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // double totalPrice = _calculateTotalPrice();
//     double totalPrice = calculateTotalPrice(products);

//     return BlocListener<payment.PaymentBloc, payment.PaymentState>(
//       listener: (context, state) {
//         //success
//         if (state is payment.PaymentSuccess) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OrderConfirmationScreen(
//                 paymentId: state.paymentId,
//                 orderId: state.orderId,
//                 address:
//                     context.read<CheckoutBloc>().state.selectedAddress ?? '',
//                 amount: totalPrice,
//               ),
//             ),
//           );
//           //failed
//         } else if (state is payment.PaymentError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Order failed: ${state.errorMessage}')),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Checkout'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Delivering To',
//               ),
//               BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   if (state.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return GestureDetector(
//                     onTap: () async {
//                       final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SelectAddressScreen()),
//                       );
//                       if (selectedAddress is String) {
//                         context
//                             .read<CheckoutBloc>()
//                             .add(SelectAddress(selectedAddress));
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         state.selectedAddress ?? 'Select Address',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(thickness: 0.6),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final item = products[index];
//                     return Card(
//                       color: AppColors.light,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 6),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.memory(
//                                 decodeBase64Image(item.imageUrls.first),
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     '₹${item.price} | Qty: ${item.quantity}',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     PriceRowWidget(title: "Subtotal", value: "₹$totalPrice"),
//                     //const PriceRowWidget(title: "Delivery Fee", value: "Free"),
//                     PriceRowWidget(
//                         title: "Delivery Fee",
//                         value: totalPrice < 600 ? "₹40" : "Free"),
//                     const Divider(),
//                     PriceRowWidget(
//                         title: "Total", value: "₹$totalPrice", isBold: true),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               //C u s t o m   b u t t o n -->
//               CustomOrangeButton(
//                 width: 300,
//                 text: 'Place Order',
//                 onPressed: () {
//                   final selectedAddress =
//                       context.read<CheckoutBloc>().state.selectedAddress;
//                   if (selectedAddress == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Please select a delivery address')),
//                     );
//                     return;
//                   }
//                   context.read<payment.PaymentBloc>().add(
//                         payment.InitiatePayment(
//                           amount: totalPrice,
//                           address: selectedAddress,
//                           userEmail: 'USER_EMAIL',
//                           items: products,
//                         ),
//                       );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//--------------------------------------------------
//backend node js + working .
//--------------------------------------------------

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../common/app_colors.dart';
// import '../checkout_screen/bloc/checkout_bloc.dart';
// import '../checkout_screen/bloc/checkout_event.dart';
// import '../checkout_screen/bloc/checkout_state.dart';
// import '../checkout_screen/select_address_screen.dart';
// import '../cart/cart_model.dart';
// import '../../widgets/custom_orange_button.dart';

// class CheckoutScreen extends StatelessWidget {
//   final List<CartItem> products;

//   const CheckoutScreen({super.key, required this.products});

//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // double totalPrice = _calculateTotalPrice();
//     double totalPrice = calculateTotalPrice(products);

//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is PaymentSuccess) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OrderConfirmationScreen(
//                 paymentId: state.paymentId,
//                 orderId: state.orderId,
//                 address:
//                     context.read<CheckoutBloc>().state.selectedAddress ?? '',
//                 amount: totalPrice,
//               ),
//             ),
//           );
//         }

//         if (state is PaymentFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Checkout'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Delivering To',
//               ),
//               BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   if (state.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return GestureDetector(
//                     onTap: () async {
//                       final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SelectAddressScreen()),
//                       );
//                       if (selectedAddress is String) {
//                         context
//                             .read<CheckoutBloc>()
//                             .add(SelectAddress(selectedAddress));
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         state.selectedAddress ?? 'Select Address',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(thickness: 0.6),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final item = products[index];
//                     return Card(
//                       color: AppColors.light,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 6),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.memory(
//                                 decodeBase64Image(item.imageUrls.first),
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     '₹${item.price} | Qty: ${item.quantity}',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     PriceRowWidget(title: "Subtotal", value: "₹$totalPrice"),
//                     //const PriceRowWidget(title: "Delivery Fee", value: "Free"),
//                     PriceRowWidget(
//                         title: "Delivery Fee",
//                         value: totalPrice < 600 ? "₹40" : "Free"),
//                     const Divider(),
//                     PriceRowWidget(
//                         title: "Total", value: "₹$totalPrice", isBold: true),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               //C u s t o m   b u t t o n -->
//               CustomOrangeButton(
//                 width: 300,
//                 text: 'Place Order',
//                 onPressed: () {
//                   final selectedAddress =
//                       context.read<CheckoutBloc>().state.selectedAddress;

//                   if (selectedAddress == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Please select a delivery address')),
//                     );
//                     return;
//                   }

//                   context.read<OrderBloc>().add(
//                         PlaceOrder(
//                           amount: totalPrice,
//                           address: selectedAddress,
//                           items: products,
//                         ),
//                       );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// //-------------------------------------------------------
// //payement verification and order
// //----------------------------------------------------------
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../common/app_colors.dart';
// import '../checkout_screen/bloc/checkout_bloc.dart';
// import '../checkout_screen/bloc/checkout_event.dart';
// import '../checkout_screen/bloc/checkout_state.dart';
// import '../checkout_screen/select_address_screen.dart';
// import '../cart/cart_model.dart';
// import '../../widgets/custom_orange_button.dart';

// class CheckoutScreen extends StatelessWidget {
//   final List<CartItem> products;

//   const CheckoutScreen({super.key, required this.products});

//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double totalPrice = calculateTotalPrice(products);

//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is PaymentSuccess) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OrderConfirmationScreen(
//                 paymentId: state.paymentId,
//                 orderId: state.orderId,
//                 address:
//                     context.read<CheckoutBloc>().state.selectedAddress ?? '',
//                 amount: totalPrice,
//               ),
//             ),
//           );
//         }

//         if (state is PaymentFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Checkout'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Delivering To',
//               ),
//               BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   if (state.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return GestureDetector(
//                     onTap: () async {
//                       final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SelectAddressScreen()),
//                       );
//                       if (selectedAddress is String) {
//                         context
//                             .read<CheckoutBloc>()
//                             .add(SelectAddress(selectedAddress));
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         state.selectedAddress ?? 'Select Address',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(thickness: 0.6),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final item = products[index];
//                     return Card(
//                       color: AppColors.light,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 6),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.memory(
//                                 decodeBase64Image(item.imageUrls.first),
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     '₹${item.price} | Qty: ${item.quantity}',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     PriceRowWidget(title: "Subtotal", value: "₹$totalPrice"),
//                     //const PriceRowWidget(title: "Delivery Fee", value: "Free"),
//                     PriceRowWidget(
//                         title: "Delivery Fee",
//                         value: totalPrice < 600 ? "₹40" : "Free"),
//                     const Divider(),
//                     PriceRowWidget(
//                         title: "Total", value: "₹$totalPrice", isBold: true),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               //C u s t o m   b u t t o n -->
//               CustomOrangeButton(
//                 width: 300,
//                 text: 'Place Order',
//                 onPressed: () {
//                   final selectedAddress =
//                       context.read<CheckoutBloc>().state.selectedAddress;

//                   if (selectedAddress == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Please select a delivery address')),
//                     );
//                     return;
//                   }

//                   context.read<OrderBloc>().add(
//                         PlaceOrder(
//                           amount: totalPrice,
//                           address: selectedAddress,
//                           items: products,
//                         ),
//                       );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// //----------- --------------------------------------------
// //razorpay warming up - modification
// //----------------------------------------------------------
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// import '../../common/app_colors.dart';
// import '../checkout_screen/bloc/checkout_bloc.dart';
// import '../checkout_screen/bloc/checkout_event.dart';
// import '../checkout_screen/bloc/checkout_state.dart';
// import '../checkout_screen/select_address_screen.dart';
// import '../cart/cart_model.dart';
// import '../../widgets/custom_orange_button.dart';

// class CheckoutScreen extends StatefulWidget {
//   final List<CartItem> products;

//   const CheckoutScreen({super.key, required this.products});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();

//     //  PRE-WARM RAZORPAY
//     _razorpay = Razorpay();
//     _razorpay.clear();

//     //  PRE-WARM BACKEND
//     Future.microtask(() {
//       context.read<OrderBloc>().paymentRepository.pingServer();
//     });
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final products = widget.products;

//     double totalPrice = calculateTotalPrice(widget.products);

//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is PaymentSuccess) {
//           //  Clear Cart
//           context.read<CartBloc>().add(ClearCart());
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OrderConfirmationScreen(
//                 paymentId: state.paymentId,
//                 orderId: state.orderId,
//                 address:
//                     context.read<CheckoutBloc>().state.selectedAddress ?? '',
//                 amount: totalPrice,
//               ),
//             ),
//           );
//         }

//         if (state is PaymentFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Checkout'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Delivering To',
//               ),
//               BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   if (state.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return GestureDetector(
//                     onTap: () async {
//                       final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SelectAddressScreen()),
//                       );
//                       if (selectedAddress is String) {
//                         context
//                             .read<CheckoutBloc>()
//                             .add(SelectAddress(selectedAddress));
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         state.selectedAddress ?? 'Select Address',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(thickness: 0.6),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: widget.products.length,
//                   itemBuilder: (context, index) {
//                     final item = widget.products[index];
//                     return Card(
//                       color: AppColors.light,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 6),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.memory(
//                                 decodeBase64Image(item.imageUrls.first),
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     '₹${item.price} | Qty: ${item.quantity}',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     PriceRowWidget(title: "Subtotal", value: "₹$totalPrice"),
//                     //const PriceRowWidget(title: "Delivery Fee", value: "Free"),
//                     PriceRowWidget(
//                         title: "Delivery Fee",
//                         value: totalPrice < 600 ? "₹40" : "Free"),
//                     const Divider(),
//                     PriceRowWidget(
//                         title: "Total", value: "₹$totalPrice", isBold: true),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               BlocBuilder<OrderBloc, OrderState>(
//                 builder: (context, state) {
//                   final isLoading =
//                       state is OrderLoading || state is PaymentInProgress;

//                   return CustomOrangeButton(
//                     width: 300,
//                     text: isLoading ? 'Opening Payment...' : 'Place Order',
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             final selectedAddress = context
//                                 .read<CheckoutBloc>()
//                                 .state
//                                 .selectedAddress;

//                             if (selectedAddress == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content:
//                                       Text('Please select a delivery address'),
//                                 ),
//                               );
//                               return;
//                             }

//                             context.read<OrderBloc>().add(
//                                   PlaceOrder(
//                                     amount: totalPrice,
//                                     address: selectedAddress,
//                                     items: widget.products,
//                                   ),
//                                 );
//                           },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//-------------------------------------------FEB 24 --------------

// //----------- --------------------------------------------
// //razorpay warming up - modification
// //----------------------------------------------------------
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
// import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
// import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
// import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
// import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// import '../../common/app_colors.dart';
// import '../checkout_screen/bloc/checkout_bloc.dart';
// import '../checkout_screen/bloc/checkout_event.dart';
// import '../checkout_screen/bloc/checkout_state.dart';
// import '../checkout_screen/select_address_screen.dart';
// import '../cart/cart_model.dart';
// import '../../widgets/custom_orange_button.dart';

// class CheckoutScreen extends StatefulWidget {
//   final List<CartItem> products;

//   const CheckoutScreen({super.key, required this.products});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   late double totalAmount;
//   Uint8List decodeBase64Image(String base64String) {
//     return base64Decode(base64String);
//   }

//   late Razorpay _razorpay;

//   @override
//   @override
//   void initState() {
//     super.initState();

//     _razorpay = Razorpay();
//     _razorpay.clear();

//     final subtotal = calculateTotalPrice(widget.products);
//     final deliveryFee = subtotal < 600 ? 40 : 0;

//     totalAmount = subtotal + deliveryFee;

//     // warm backend - render
//     Future.microtask(() {
//       context.read<OrderBloc>().paymentRepository.pingServer();
//     });
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final products = widget.products;

//     // double totalPrice = calculateTotalPrice(widget.products);
//     final subtotal = calculateTotalPrice(widget.products);
//     final deliveryFee = subtotal < 600 ? 40 : 0;
//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is PaymentSuccess) {
//           //  Clear Cart
//           context.read<CartBloc>().add(ClearCart());
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OrderConfirmationScreen(
//                 paymentId: state.paymentId,
//                 orderId: state.orderId,
//                 address:
//                     context.read<CheckoutBloc>().state.selectedAddress ?? '',
//                 amount: totalAmount,
//               ),
//             ),
//           );
//         }

//         if (state is PaymentFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Checkout'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 'Delivering To',
//               ),
//               BlocBuilder<CheckoutBloc, CheckoutState>(
//                 builder: (context, state) {
//                   if (state.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return GestureDetector(
//                     onTap: () async {
//                       final selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SelectAddressScreen()),
//                       );
//                       if (selectedAddress is String) {
//                         context
//                             .read<CheckoutBloc>()
//                             .add(SelectAddress(selectedAddress));
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         state.selectedAddress ?? 'Select Address',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(thickness: 0.6),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: widget.products.length,
//                   itemBuilder: (context, index) {
//                     final item = widget.products[index];
//                     return Card(
//                       color: AppColors.light,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 6),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.memory(
//                                 decodeBase64Image(item.imageUrls.first),
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     '₹${item.price} | Qty: ${item.quantity}',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     PriceRowWidget(title: "Subtotal", value: "₹$subtotal"),
//                     //const PriceRowWidget(title: "Delivery Fee", value: "Free"),
//                     PriceRowWidget(
//                         title: "Delivery Fee",
//                         value: deliveryFee == 0 ? "Free" : "₹$deliveryFee"),
//                     const Divider(),
//                     PriceRowWidget(
//                         title: "Total", value: "₹$totalAmount", isBold: true),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               BlocBuilder<OrderBloc, OrderState>(
//                 builder: (context, state) {
//                   final isLoading =
//                       state is OrderLoading || state is PaymentInProgress;

//                   return CustomOrangeButton(
//                     width: 300,
//                     text: isLoading ? 'Opening Payment...' : 'Place Order',
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             final selectedAddress = context
//                                 .read<CheckoutBloc>()
//                                 .state
//                                 .selectedAddress;

//                             if (selectedAddress == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content:
//                                       Text('Please select a delivery address'),
//                                 ),
//                               );
//                               return;
//                             }
//                             final profileState =
//                                 context.read<ProfileBloc>().state;
//                             final customerName = profileState is ProfileLoaded
//                                 ? (profileState.userProfile['name'] ?? 'User')
//                                 : 'User';
//                             context.read<OrderBloc>().add(
//                                   PlaceOrder(
//                                     amount: totalAmount,
//                                     address: selectedAddress,
//                                     items: widget.products,
//                                     customerName: customerName,
//                                   ),
//                                 );
//                           },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkout_widgets/price_calculator.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_event.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_state.dart';
import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../common/app_colors.dart';
import '../checkout_screen/bloc/checkout_bloc.dart';
import '../checkout_screen/bloc/checkout_event.dart';
import '../checkout_screen/bloc/checkout_state.dart';
import '../checkout_screen/select_address_screen.dart';
import '../cart/cart_model.dart';
import '../../widgets/custom_orange_button.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> products;

  const CheckoutScreen({super.key, required this.products});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late double totalAmount;

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.clear();

    final subtotal = calculateTotalPrice(widget.products);
    final deliveryFee = subtotal < 600 ? 40 : 0;
    totalAmount = subtotal + deliveryFee;

    Future.microtask(() {
      context.read<OrderBloc>().paymentRepository.pingServer();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = calculateTotalPrice(widget.products);
    final deliveryFee = subtotal < 600 ? 40 : 0;

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          context.read<CartBloc>().add(ClearCart());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderConfirmationScreen(
                paymentId: state.paymentId,
                orderId: state.orderId,
                address:
                    context.read<CheckoutBloc>().state.selectedAddress ?? '',
                amount: totalAmount,
              ),
            ),
          );
        }

        if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, orderState) {
          final isProcessing =
              orderState is PaymentInProgress || orderState is OrderLoading;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  title: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  leading: BackButton(color: Colors.black87),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      //  Delivery address section
                      const Text(
                        'Delivering To',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<CheckoutBloc, CheckoutState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return GestureDetector(
                            onTap: () async {
                              final selectedAddress = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectAddressScreen(),
                                ),
                              );
                              if (selectedAddress is String) {
                                context
                                    .read<CheckoutBloc>()
                                    .add(SelectAddress(selectedAddress));
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: state.selectedAddress != null
                                      ? AppColors.buttonColorOrange
                                          .withOpacity(0.6)
                                      : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 18,
                                    color: state.selectedAddress != null
                                        ? AppColors.buttonColorOrange
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      state.selectedAddress ??
                                          'Select delivery address',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: state.selectedAddress != null
                                            ? Colors.black87
                                            : Colors.black38,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.black26,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Items',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.buttonColorOrange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${widget.products.length}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.buttonColorOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      //  Product list
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            final item = widget.products[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      decodeBase64Image(item.imageUrls.first),
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${item.price}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    AppColors.buttonColorOrange,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'Qty: ${item.quantity}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      //  Price summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Subtotal',
                              value: '₹$subtotal',
                            ),
                            const SizedBox(height: 8),
                            _SummaryRow(
                              label: 'Delivery Fee',
                              value:
                                  deliveryFee == 0 ? 'Free' : '₹$deliveryFee',
                              valueColor: deliveryFee == 0
                                  ? Colors.green
                                  : Colors.black87,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1, thickness: 0.5),
                            ),
                            _SummaryRow(
                              label: 'Total',
                              value: '₹$totalAmount',
                              isBold: true,
                              valueColor: AppColors.buttonColorOrange,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Place Order button
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          final isLoading = state is OrderLoading ||
                              state is PaymentInProgress;

                          return CustomOrangeButton(
                            width: double.infinity,
                            text: isLoading
                                ? 'Opening Payment...'
                                : 'Place Order  ₹$totalAmount',
                            onPressed: isLoading
                                ? null
                                : () {
                                    final selectedAddress = context
                                        .read<CheckoutBloc>()
                                        .state
                                        .selectedAddress;

                                    if (selectedAddress == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please select a delivery address'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      return;
                                    }

                                    final profileState =
                                        context.read<ProfileBloc>().state;
                                    final customerName = profileState
                                            is ProfileLoaded
                                        ? (profileState.userProfile['name'] ??
                                            'User')
                                        : 'User';

                                    context.read<OrderBloc>().add(
                                          PlaceOrder(
                                            amount: totalAmount,
                                            address: selectedAddress,
                                            items: widget.products,
                                            customerName: customerName,
                                          ),
                                        );
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              //  processing overlay
              if (isProcessing)
                Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.buttonColorOrange,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Confirming your order...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Please do not close the app',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// Local summary row widget

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? Colors.black87 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
