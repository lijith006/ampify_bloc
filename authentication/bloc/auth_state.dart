import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;

  AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
