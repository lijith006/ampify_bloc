// // import 'package:equatable/equatable.dart';

// // abstract class AuthEvent extends Equatable {
// //   const AuthEvent();

// //   @override
// //   List<Object> get props => [];
// // }

// // class LoginRequested extends AuthEvent {
// //   final String email;
// //   final String password;

// //   const LoginRequested(this.email, this.password);
// // }

// // class SignUpRequested extends AuthEvent {
// //   final String email;
// //   final String password;

// //   const SignUpRequested(this.email, this.password);
// // }

// // class GoogleSignInRequested extends AuthEvent {}

// // class LogoutRequested extends AuthEvent {}

// import 'package:equatable/equatable.dart';

// abstract class AuthEvent extends Equatable {
//   const AuthEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoginRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const LoginRequested(this.email, this.password);
// }

// class SignUpRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const SignUpRequested(this.email, this.password);
// }

// class GoogleSignInRequested extends AuthEvent {}

// class LogoutRequested extends AuthEvent {}
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SendPasswordResetLink extends AuthEvent {
  final String email;

  SendPasswordResetLink({required this.email});
}

class LoginWithGoogle extends AuthEvent {}

class CreateUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  CreateUserWithEmailAndPassword({required this.email, required this.password});
}

class LoginUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  LoginUserWithEmailAndPassword(this.email, this.password);
}

class Signout extends AuthEvent {}

class SignOutRequested extends AuthEvent {}
