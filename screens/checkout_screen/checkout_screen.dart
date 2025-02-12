import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final CartItem product;
  const CheckoutScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
    );
  }
}
