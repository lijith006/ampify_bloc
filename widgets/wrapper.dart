// // // import 'package:ampify_bloc/authentication/screens/login_screen_orginal.dart';
// // // import 'package:ampify_bloc/screens/home/Home_screen.dart';
// // import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// // import 'package:ampify_bloc/authentication/screens/login_screen.dart';
// // import 'package:ampify_bloc/screens/home/home_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../authentication/bloc/auth_state.dart';

// // class Wrapper extends StatelessWidget {
// //   const Wrapper({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: BlocBuilder<AuthBloc, AuthState>(
// //         builder: (context, state) {
// //           //  loading state
// //           // if (state is AuthLoading) {
// //           //   return const Center(
// //           //       // child: SpinKitWave(
// //           //       //   color: Color.fromARGB(255, 37, 40, 43),
// //           //       //   size: 35.0,
// //           //       // ),

// //           //       // child: CircularProgressIndicator(),
// //           //       );
// //           // }

// //           //  error state
// //           if (state is AuthError) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   const Icon(Icons.error_outline, color: Colors.red, size: 50),
// //                   const SizedBox(height: 10),
// //                   Text(
// //                     state.message,
// //                     style: const TextStyle(color: Colors.red, fontSize: 16),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ],
// //               ),
// //               //  Text(state.message),
// //             );
// //           }

// //           if (state is AuthSuccess && state.user != null) {
// //             return const HomeScreen();
// //           } else {
// //             return const LoginScreen();
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// //EXP

import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/screens/home/home_screen.dart';
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
//Success state

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

// import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// import 'package:ampify_bloc/authentication/bloc/auth_state.dart';
// import 'package:ampify_bloc/authentication/screens/login_screen.dart';
// import 'package:ampify_bloc/authentication/screens/verification_screen.dart';
// import 'package:ampify_bloc/screens/home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthSuccess) {
//           if (state.user != null && state.user!.emailVerified) {
//             // Navigate to Home if the user is logged in and email is verified
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//           } else {
//             // Navigate to Verify Email screen if email is not verified
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => VerificationScreen()),
//             );
//           }
//         } else if (state is AuthInitial || state is AuthError) {
//           // Navigate to Login screen if not logged in
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginScreen()),
//           );
//         } else if (state is AuthEmailVerificationSent) {
//           // Show dialog for verification email sent
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Verify Your Email'),
//               content: Text(
//                   'A verification email has been sent to your email address. Please verify your email before logging in.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Okay'),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         body: Center(
//           child:
//               CircularProgressIndicator(), // Show loading while state is being resolved
//         ),
//       ),
//     );
//   }
// }
