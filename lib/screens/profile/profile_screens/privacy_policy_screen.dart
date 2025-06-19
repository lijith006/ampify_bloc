import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final Uri privacyPolicyUrl = Uri.parse(
      "https://www.termsfeed.com/live/0d4f577c-9ea8-4c41-b743-7a56f5683f3a");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ampify Privacy Policy',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'At Ampify, we value your privacy and are committed to protecting your personal information. '
                      'This Privacy Policy outlines how we collect, use, and safeguard your data.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Information We Collect',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '• Personal Details: Name, email, contact number, and shipping address.\n'
                      '• Payment Information: We use secure payment gateways and do not store your payment details.\n'
                      '• Usage Data: Analytics to improve user experience and provide better recommendations.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'How We Use Your Data',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '• To process and deliver your orders securely.\n'
                      '• To provide customer support and assistance.\n'
                      '• To send order updates, promotions, and personalized recommendations.\n'
                      '• To improve the Ampify shopping experience.',
                      style: TextStyle(fontSize: 16),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.open_in_new, color: Colors.blue),
              title: const Text(
                "Read Full Privacy Policy",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              onTap: () async {
                if (await canLaunchUrl(privacyPolicyUrl)) {
                  await launchUrl(privacyPolicyUrl,
                      mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Could not open privacy policy link")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
