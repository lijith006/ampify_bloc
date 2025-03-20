import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/screens/checkout_screen/checkout_widget/price_row_widget.dart';
import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
import 'package:ampify_bloc/screens/payment/bloc/payment_bloc.dart' as payment;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_colors.dart';
import '../checkout_screen/bloc/checkout_bloc.dart';
import '../checkout_screen/bloc/checkout_event.dart';
import '../checkout_screen/bloc/checkout_state.dart';
import '../checkout_screen/select_address_screen.dart';
import '../cart/cart_model.dart';
import '../../widgets/custom_orange_button.dart';
import '../../widgets/widget_support.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> products;

  const CheckoutScreen({super.key, required this.products});

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  double _calculateTotalPrice() {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return BlocListener<payment.PaymentBloc, payment.PaymentState>(
      listener: (context, state) {
        //success
        if (state is payment.PaymentSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(
                paymentId: state.paymentId,
                orderId: state.orderId,
                address:
                    context.read<CheckoutBloc>().state.selectedAddress ?? '',
                amount: totalPrice,
              ),
            ),
          );
          //failed
        } else if (state is payment.PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('C h e c k o u t'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Delivering To', style: AppWidget.boldTextFieldStyle()),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () async {
                      final selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectAddressScreen()),
                      );
                      if (selectedAddress is String) {
                        context
                            .read<CheckoutBloc>()
                            .add(SelectAddress(selectedAddress));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.selectedAddress ?? 'Select Address',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
              const Divider(thickness: 0.6),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return Card(
                      color: AppColors.light,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                decodeBase64Image(item.imageUrls.first),
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppWidget.boldTextFieldStyleSmall(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '₹${item.price} | Qty: ${item.quantity}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 2),
                  ],
                ),
                child: Column(
                  children: [
                    PriceRowWidget(title: "Subtotal", value: "₹$totalPrice"),
                    const PriceRowWidget(title: "Delivery Fee", value: "Free"),
                    const Divider(),
                    PriceRowWidget(
                        title: "Total", value: "₹$totalPrice", isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Custom button
              CustomOrangeButton(
                width: 300,
                text: 'Place Order',
                onPressed: () {
                  final selectedAddress =
                      context.read<CheckoutBloc>().state.selectedAddress;
                  if (selectedAddress == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select a delivery address')),
                    );
                    return;
                  }
                  context.read<payment.PaymentBloc>().add(
                        payment.InitiatePayment(
                          amount: totalPrice,
                          address: selectedAddress,
                          userEmail: 'USER_EMAIL',
                          items: products,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
