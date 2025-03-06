//**********************************MARCH 04 ************** */

import 'dart:convert';
import 'dart:typed_data';

import 'package:ampify_bloc/screens/order_tracking_screen/order_tracking_screen.dart';
import 'package:ampify_bloc/screens/orders/order_confirmation_screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../orders/bloc/order_bloc.dart';
import '../orders/bloc/order_event.dart';
import '../orders/bloc/order_state.dart';
import '../../common/app_colors.dart';
import '../checkout_screen/bloc/checkout_bloc.dart';
import '../checkout_screen/bloc/checkout_event.dart';
import '../checkout_screen/bloc/checkout_state.dart';
import '../checkout_screen/select_address_screen.dart';
import '../cart/cart_model.dart';
import '../../widgets/custom_orange_button.dart';
import '../../widgets/widget_support.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> products;
  const CheckoutScreen({super.key, required this.products});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    //place order after successful payment
    context.read<OrderBloc>().add(
          PlaceOrder(
            amount: _calculateTotalPrice(),
            orderId: response.orderId ?? '',
            paymentId: response.paymentId ?? '',
            items: widget.products,
            address: context.read<CheckoutBloc>().state.selectedAddress ?? '',
            userEmail: 'USER_EMAIL',
          ),
        );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderTrackingScreen(orderId: response.paymentId ?? ''),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _initiatePayment() {
    // Validate address
    final selectedAddress = context.read<CheckoutBloc>().state.selectedAddress;
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    // Razorpay payment options
    var options = {
      'key': 'rzp_test_FRLD6BPBYxystN',
      'amount': (_calculateTotalPrice() * 100).toInt(), //paise
      'name': 'Ampify',
      'description': 'Product Purchase',
      'prefill': {'email': 'USER_EMAIL'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Initiation Failed: $e')),
      );
    }
  }

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  double _calculateTotalPrice() {
    return widget.products
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderPlaced) {
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
        } else if (state is OrderFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${state.error}')),
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
              Text(
                'Delivering To',
                style: AppWidget.boldTextFieldStyle(),
              ),
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
                            builder: (context) => const SelectAddressScreen(),
                          ));

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
                          borderRadius: BorderRadius.circular(8)),
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
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final item = widget.products[index];
                    return Card(
                      color: Colors.white,
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
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
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
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildPriceRow("Subtotal", "₹$totalPrice"),
                    _buildPriceRow("Delivery Fee", "Free"),
                    const Divider(),
                    _buildPriceRow("Total", "₹$totalPrice", isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomOrangeButton(
                width: 300,
                text: 'Place Order',
                onPressed: _initiatePayment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
