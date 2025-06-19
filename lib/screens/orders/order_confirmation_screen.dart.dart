import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/orders/order_widgets/order_confirmation_build_row.dart';
import 'package:ampify_bloc/widgets/confetti.dart';
import 'package:ampify_bloc/widgets/custom_nav/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/home/home_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;
  final String paymentId;
  final String address;
  final double amount;

  const OrderConfirmationScreen({
    super.key,
    required this.paymentId,
    required this.orderId,
    required this.address,
    required this.amount,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Confetti Animation
          const ConfettiEffect(),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  title: const Text(
                    "Order Confirmation",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      context.read<CartBloc>().add(ClearCart());
                      context.read<NavCubit>().updateIndex(0);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.close, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 20),

                Lottie.asset('assets/animations/tick_mark.json',
                    width: 200, height: 200, repeat: false),

                const SizedBox(height: 10),

                // Order Details Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Your order has been placed successfully!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OrderDetailRow(
                            label: "Order ID:", value: widget.orderId),
                        OrderDetailRow(
                            label: "Payment ID:", value: widget.paymentId),
                        OrderDetailRow(
                            label: "Delivering to:", value: widget.address),
                        OrderDetailRow(
                            label: "Total Amount:", value: "₹${widget.amount}"),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
