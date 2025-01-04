import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/screens/Home_screen.dart';
import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/bloc/auth_state.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          //  loading state
          // if (state is AuthLoading) {
          //   return const Center(
          //       // child: SpinKitWave(
          //       //   color: Color.fromARGB(255, 37, 40, 43),
          //       //   size: 35.0,
          //       // ),

          //       // child: CircularProgressIndicator(),
          //       );
          // }

          //  error state
          if (state is AuthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              //  Text(state.message),
            );
          }

          if (state is AuthSuccess && state.user != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
