import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';

import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter email to reset password'),
            const SizedBox(
              height: 10,
            ),
            Customtextformfield(
              controller: _email,
              labelText: 'Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                label: 'Send Email',
                onTap: () async {
                  await _auth.sendPasswordResetLink(_email.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'An email for password reset has been send to your email')));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
