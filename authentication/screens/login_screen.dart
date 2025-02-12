import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/screens/forgot-password.dart';
import 'package:ampify_bloc/authentication/screens/signup_screen.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/home/home_screen.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:ampify_bloc/widgets/validators_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 243, 236, 236),
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Login',
          style: TextStyle(fontSize: 26),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  //EXP im
                  Column(
                    children: [
                      Center(
                        child: Image.asset(
                          // 'assets/images/login3.png',
                          'assets/images/logscrn.png',
                          height: 320,
                          width: 320,
                        ),
                      ),
                    ],
                  ),

                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixicon: const Icon(Icons.email_outlined),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      bool isPasswordVisible = false;
                      //Listen for state changes
                      if (state is AuthPasswordVisibilityChanged) {
                        isPasswordVisible = state.isPasswordVisible;
                      }
                      return CustomTextFormField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: !isPasswordVisible,
                        prefixicon: const Icon(Icons.password_outlined),
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                TogglePasswordVisibility(!isPasswordVisible));
                          },
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style:
                            TextStyle(color: Color.fromARGB(255, 50, 86, 116)),
                      ),
                    ),
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Center(
                        child: CustomButton(
                          label: 'Login',
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthBloc>().add(
                                    LoginUserWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  // const SizedBox(height: 5),
                  // const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  const Center(child: Text('Or login with Google account')),
                  const SizedBox(height: 5),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: SpinKitWave(
                            color: Colors.black45,
                            size: 35.0,
                          ),
                        );
                      } else {
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
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              color: Color.fromARGB(255, 50, 86, 116)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
