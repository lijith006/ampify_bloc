import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ampify_bloc/repositories/payment_repository.dart';

class AppInitializer extends StatefulWidget {
  final Widget child;

  const AppInitializer({super.key, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();

    // Warm backend
    Future.microtask(() {
      context.read<PaymentRepository>().pingServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
