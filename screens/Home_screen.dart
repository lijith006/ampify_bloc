import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/authentication/service/auth_service.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            const Text('Home'),
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
        )),
      ),
    );
  }
}
