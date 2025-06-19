// part of 'auth_bloc.dart';

// @immutable
// sealed class AuthEvent {}

// class SendPasswordResetLink extends AuthEvent {
//   final String email;

//   SendPasswordResetLink({required this.email});
// }

// class LoginWithGoogle extends AuthEvent {}

// class CreateUserWithEmailAndPassword extends AuthEvent {
//   final String email;
//   final String password;

//   CreateUserWithEmailAndPassword({required this.email, required this.password});
// }

// class LoginUserWithEmailAndPassword extends AuthEvent {
//   final String email;
//   final String password;
//   LoginUserWithEmailAndPassword(this.email, this.password);
// }

// class Signout extends AuthEvent {}

// class SignOutRequested extends AuthEvent {}

// class TogglePasswordVisibility extends AuthEvent {
//   final bool isPasswordVisible;

//   TogglePasswordVisibility(this.isPasswordVisible);
// }

//......*********************************************

part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SendPasswordResetLink extends AuthEvent {
  final String email;

  SendPasswordResetLink({required this.email});
}

class LoginWithGoogle extends AuthEvent {}

class CreateUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  final String? base64Image;
  final String name;

  CreateUserWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.name,
    this.base64Image,
  });
}

class LoginUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  LoginUserWithEmailAndPassword(this.email, this.password);
}

class Signout extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class TogglePasswordVisibility extends AuthEvent {
  final bool isPasswordVisible;

  TogglePasswordVisibility(this.isPasswordVisible);
}
