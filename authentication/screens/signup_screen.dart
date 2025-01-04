import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/screens/Home_screen.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Signup',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 30),
                  Customtextformfield(
                    controller: _nameController,
                    labelText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return 'Name must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Customtextformfield(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Customtextformfield(
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoading) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing up...')),
                        );
                      }
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signup Successful!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                        // Navigator.pop(context);
                      }
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: Center(
                      child: CustomButton(
                        label: 'SignUp',
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // ..--Trigger the sign-up event in the BLoC---------
                            context.read<AuthBloc>().add(
                                  CreateUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),
                  const Center(child: Text('Or login with Google account')),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: SpinKitWave(
                            color: Colors.blue,
                            size: 35.0,
                          ),
                        );
                      }
                      return Center(
                        child: InkWell(
                          onTap: () {
                            context.read<AuthBloc>().add(LoginWithGoogle());
                          },
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/images/google.png'),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
