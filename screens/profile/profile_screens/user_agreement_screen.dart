import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Agreement')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ampify User Agreement',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'By using Ampify, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Ordering & Delivery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Orders are processed after payment confirmation.\n'
              '• Estimated delivery time: 0-14 days across India.\n'
              '• Ampify ensures secure packaging and timely shipping.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Returns & Replacement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• You can request a replacement within 7 days of delivery if the product is defective.\n'
              '• The item must be returned in its original condition and packaging.\n'
              '• Ampify reserves the right to deny returns if the product is damaged due to misuse.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Warranty Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• All products sold on Ampify come with a valid company warranty.\n'
              '• Warranty claims must be made directly through the manufacturer.\n'
              '• Ampify is not responsible for warranty decisions made by the manufacturer.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
