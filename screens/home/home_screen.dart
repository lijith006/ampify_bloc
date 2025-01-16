// import 'package:ampify_bloc/authentication/screens/login_screen_orginal.dart';
import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Hi,Amal',
              style: AppWidget.boldTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Catagories',
              style: AppWidget.lightTextFieldStyle(),
            ),
            Row(),
            ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
