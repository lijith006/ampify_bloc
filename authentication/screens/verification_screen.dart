// // import 'dart:async';

// // import 'package:ampify_bloc/authentication/service/auth_service.dart';
// // import 'package:ampify_bloc/widgets/custom_button.dart';
// // import 'package:ampify_bloc/widgets/wrapper.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';

// // class VerificationScreen extends StatefulWidget {
// //   const VerificationScreen({super.key});

// //   @override
// //   State<VerificationScreen> createState() => _VerificationScreenState();
// // }

// // class _VerificationScreenState extends State<VerificationScreen> {
// //   final _auth = AuthService();
// //   late Timer timer;
// //   @override
// //   void initState() {
// //     _auth.sendEmailVerificationLink();
// //     timer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //       FirebaseAuth.instance.currentUser?.reload();
// //       if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
// //         timer.cancel();
// //         Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => const Wrapper(),
// //             ));
// //       }
// //     });
// //     super.initState();
// //   }

// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         shadowColor: Colors.transparent,
// //       ),
// //       extendBodyBehindAppBar: true,
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           image: DecorationImage(
// //               image: AssetImage('assets/images/background.jpg'),
// //               fit: BoxFit.cover),
// //         ),
// //         child: SizedBox.expand(
// //           child: Padding(
// //             padding: const EdgeInsets.all(10),
// //             child: Column(
// //               children: [
// //                 const Text(
// //                     "We have sent an email for verification.If you haven't received click resent."),
// //                 const SizedBox(
// //                   height: 20,
// //                 ),
// //                 CustomButton(
// //                     label: 'Re-send Email',
// //                     onTap: () async {
// //                       _auth.sendEmailVerificationLink();
// //                     })
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'dart:async';

// import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// import 'package:ampify_bloc/authentication/bloc/auth_state.dart';
// // import 'package:ampify_bloc/authentication/service/auth_service.dart';
// import 'package:ampify_bloc/widgets/custom_button.dart';
// import 'package:ampify_bloc/widgets/wrapper.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   // final _auth = AuthService();
//   // late Timer timer;
//   // @override
//   // void initState() {
//   //   _auth.sendEmailVerificationLink();
//   //   timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//   //     FirebaseAuth.instance.currentUser?.reload();
//   //     if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
//   //       timer.cancel();
//   //       Navigator.pushReplacement(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => const Wrapper(),
//   //           ));
//   //     }
//   //   });
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         shadowColor: Colors.transparent,
//       ),
//       extendBodyBehindAppBar: true,
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           // TODO: implement listener
//           if (state is AuthSuccess && state.user!.emailVerified) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => Wrapper(),
//               ),
//             );
//           } else if (state is AuthEmailVerificationSent) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Verification email re-sent!')),
//             );
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           return Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/images/background.jpg'),
//                     fit: BoxFit.cover),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     const Text(
//                         "We have sent an email for verification.If you haven't received click resent."),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     CustomButton(
//                       label: 'Re-send Email',
//                       onTap: () async {
//                         context.read<AuthBloc>().add(ResendEmailVerification());
//                         //                       })
//                         //                 ],
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     );
//                         //   }
//                         // }
//                       },
//                     ),
//                   ],
//                 ),
//               ));
//         },
//       ),
//     );
//   }
// }
