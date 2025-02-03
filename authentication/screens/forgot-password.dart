import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:ampify_bloc/widgets/validators_widget.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        // title: const Text(
        //   'Forgot password',
        //   style: TextStyle(
        //       fontSize: 30, fontWeight: FontWeight.w400, color: Colors.white),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover)),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Forgot password',
                        style: AppWidget.screenHeading(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/forgotPassword.png',
                        height: 350,
                        width: 350,
                      ),
                    ),
                  ],
                ),
                const Text('Enter email to reset password'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  controller: _email,
                  labelText: 'Email',
                  validator: Validators.validateEmail,
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
        ),
      ),
    );
  }
}
