import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/notification/fcm_token_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<SendPasswordResetLink>((event, emit) async {
      emit(AuthLoading());

      try {
        await _authService.sendPasswordResetLink(event.email);
        emit(AuthSuccess(user: null));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
//Google login
    on<LoginWithGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.loginWithGoogle();
        if (userCredential != null && userCredential.user != null) {
          final user = userCredential.user!;
          debugPrint('Google user signed in with UID: ${user.uid}');

          // Save user data to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'name': user.displayName ?? 'Unknown',
            'profileImage': user.photoURL ?? '',
          }, SetOptions(merge: true));
          //);
//  Save the FCM Token after login
          await FCMTokenHandler.saveTokenToFirestore(user.uid);
          debugPrint('Google user data saved to Firestore successfully.');
          emit(AuthSuccess(user: user));
        }
      } catch (e) {
        debugPrint('Error during Google Sign-In: $e');
        emit(AuthError(message: e.toString()));
      }
    });

//SIGN UP
    on<CreateUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.createUserWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          debugPrint('User created with UID: ${user.uid}');
          debugPrint('Saving user data to Firestore...');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': event.email,
            'name': event.name,
            'profileImage': event.base64Image, // Store Base64 image
          });

          // Save FCM Token
          await FCMTokenHandler.saveTokenToFirestore(user.uid);

          debugPrint('User data saved to Firestore successfully.');
          emit(AuthSuccess(user: user));
        }
        //emit(AuthSuccess(user: user));
      } catch (e) {
        debugPrint('Error saving user data to Firestore: $e');
        emit(AuthError(message: e.toString()));
      }
    });
//Login with Email and Password
    on<LoginUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.loginUserWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          debugPrint('Login successful, user UID: ${user.uid}');
          //  Save/Update token
          await FCMTokenHandler.saveTokenToFirestore(user.uid);
          emit(AuthSuccess(user: user));
        } else {
          debugPrint('Login failed: Incorrect credentials');

          emit(AuthError(message: 'Incorrect credentials'));
        }
      } catch (e) {
        debugPrint('Login error: $e');
        emit(AuthError(message: e.toString()));
      }
    });

//!signout
    on<Signout>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authService.signOut();
          debugPrint('Logout successful');
          emit(AuthInitial());
        } catch (e) {
          debugPrint('Logout error: $e');
          emit(AuthError(message: 'Failed to log out'));
        }
      },
    );
    // Toggle password visibility
    on<TogglePasswordVisibility>((event, emit) {
      emit(AuthPasswordVisibilityChanged(event.isPasswordVisible));
    });
  }
}
