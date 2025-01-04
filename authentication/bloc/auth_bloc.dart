import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:bloc/bloc.dart';
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

    on<LoginWithGoogle>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final userCredential = await _authService.loginWithGoogle();
          emit(AuthSuccess(user: userCredential?.user));
        } catch (e) {
          emit(AuthError(message: e.toString()));
        }
      },
    );

    on<CreateUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.createUserWithEmailAndPassword(
            event.email, event.password);
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.loginUserWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthError(message: 'Incorrect credentials'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

//!signout
    on<Signout>(
      (event, emit) async {
        try {
          await _authService.signOut();
          emit(AuthInitial());
        } catch (e) {
          emit(AuthError(message: e.toString()));
        }
      },
    );
  }
}
