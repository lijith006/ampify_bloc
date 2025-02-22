// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   //final _auth = FirebaseAuth.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User? get currentUser => _auth.currentUser;
//   // Future<User?> createUserWithEmailAndPassword(
//   //     String email, String password) async {
//   //   try {
//   //     final cred = await _auth.createUserWithEmailAndPassword(
//   //         email: email, password: password);
//   //     final user = cred.user;
//   //     if (user != null && !user.emailVerified) {
//   //       await user.sendEmailVerification(); // Send verification email
//   //     }
//   //     await signOut(); // Immediately log out the user after signup
//   //     return user;
//   //   } on FirebaseAuthException catch (e) {
//   //     exceptionHandler(e.code);
//   //   } catch (e) {
//   //     print("Unexpected error: $e");
//   //   }
//   //   return null;
//   // }

//   Future<User?> createUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final cred = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return cred.user;
//     } on FirebaseAuthException catch (e) {
//       exceptionHandler(e.code);
//       // print("Error: ${e.message}");
//     } catch (e) {
//       print("Unexpected error: $e");
//     }
//     return null;
//   }

//   Future<void> sendEmailVerificationLink() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         await user.sendEmailVerification();
//       } else {
//         throw Exception('No user is currently signed in.');
//       }
//     } catch (e) {
//       debugPrint('Error sending email verification: $e');
//       throw e; // Re-throw for BLoC to handle.
//     }
//   }

//   Future<UserCredential?> loginWithGoogle() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       final googleAuth = await googleUser?.authentication;
//       final cred = GoogleAuthProvider.credential(
//           idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
//       return await _auth.signInWithCredential(cred);
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   Future<void> sendPasswordResetLink(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<User?> loginUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final cred = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return cred.user;
//     } on FirebaseAuthException catch (e) {
//       exceptionHandler(e.code);
//     } catch (e) {
//       print("Unexpected error: $e");
//     }

//     return null;
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await GoogleSignIn().signOut();
//     } catch (e) {
//       print("Something went wrong");
//     }
//   }
// }

// exceptionHandler(String code) {
//   switch (code) {
//     case "invalid-credential":
//       print('Your login credentials are invalid');
//     case "weak-password":
//       print('Your password must be atleast 6 characters');
//     case "email-already-in-use":
//       print('User already exists');
//     default:
//       print('Something went wrong');
//   }
// }

// //**************************************** */
//***************************************** */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //final _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
      // print("Error: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    }
    return null;
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw Exception('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error sending email verification: $e');
      throw e; // Re-throw for BLoC to handle.
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      print("Unexpected error: $e");
    }

    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print("Something went wrong");
    }
  }
}

exceptionHandler(String code) {
  switch (code) {
    case "invalid-credential":
      print('Your login credentials are invalid');
    case "weak-password":
      print('Your password must be atleast 6 characters');
    case "email-already-in-use":
      print('User already exists');
    default:
      print('Something went wrong');
  }
}

//**************************************** */
