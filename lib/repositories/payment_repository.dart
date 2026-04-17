import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentRepository {
  final String baseUrl;
  final http.Client _client = http.Client();

  PaymentRepository({required this.baseUrl});

  Future<String> createOrder(double amount) async {
    final response = await _client
        .post(
          Uri.parse('$baseUrl/payments/create-order'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'amount': amount}),
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException(
              'Server is waking up, please try again in a moment.'),
        );

    if (response.statusCode != 200) {
      throw Exception('Failed to create Razorpay order');
    }

    final data = jsonDecode(response.body);
    return data['orderId'];
  }

  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final response = await _client
        .post(
          Uri.parse('$baseUrl/payments/verify-payment'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'razorpay_order_id': orderId,
            'razorpay_payment_id': paymentId,
            'razorpay_signature': signature,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  Future<void> pingServer() async {
    try {
      await _client
          .get(Uri.parse('$baseUrl/ping'))
          .timeout(const Duration(seconds: 20));
    } catch (_) {}
  }

  void dispose() {
    _client.close();
  }
}
