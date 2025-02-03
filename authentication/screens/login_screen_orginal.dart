// import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// import 'package:ampify_bloc/authentication/screens/forgot-password.dart';
// import 'package:ampify_bloc/authentication/screens/signup_screen.dart';
// import 'package:ampify_bloc/screens/home/home_screen.dart';
// // import 'package:ampify_bloc/screens/home/Home_screen.dart';
// import 'package:ampify_bloc/widgets/custom_button.dart';
// import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import '../bloc/auth_state.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final _emailController = TextEditingController();
//     final _passwordController = TextEditingController();
//     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Form(
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 50),
//                   const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
//                   ),
//                   const SizedBox(height: 30),
//                   Customtextformfield(
//                     controller: _emailController,
//                     labelText: 'Username',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                           .hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Customtextformfield(
//                     controller: _passwordController,
//                     labelText: 'Password',
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       } else if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ForgotPassword(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Forgot your password?',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                   BlocConsumer<AuthBloc, AuthState>(
//                     listener: (context, state) {
//                       if (state is AuthSuccess) {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       }
//                       if (state is AuthError) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(state.message)),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       return CustomButton(
//                         label: 'Login',
//                         onTap: () {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             context.read<AuthBloc>().add(
//                                   LoginUserWithEmailAndPassword(
//                                     _emailController.text,
//                                     _passwordController.text,
//                                   ),
//                                 );
//                           }
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   const Divider(thickness: 1),
//                   const SizedBox(height: 20),
//                   const Center(child: Text('Or login with Google account')),
//                   const SizedBox(height: 20),
//                   BlocBuilder<AuthBloc, AuthState>(
//                     builder: (context, state) {
//                       if (state is AuthLoading) {
//                         return const Center(
//                           child: SpinKitWave(
//                             color: Colors.blue,
//                             size: 35.0,
//                           ),
//                         );
//                       } else {
//                         return Center(
//                           child: InkWell(
//                             onTap: () {
//                               context.read<AuthBloc>().add(LoginWithGoogle());
//                             },
//                             child: SizedBox(
//                               width: 50,
//                               height: 50,
//                               child: Image.asset('assets/images/google.png'),
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SignUpScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Register now",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
