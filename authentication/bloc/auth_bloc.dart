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
//Google login
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
//Creating - Signup
    // on<CreateUserWithEmailAndPassword>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     final user = await _authService.createUserWithEmailAndPassword(
    //         event.email, event.password);
    //     if (user != null) {
    //       emit(
    //           AuthEmailVerificationSent()); // Notify that email verification is required
    //     } else {
    //       emit(AuthError(message: 'Failed to create user.'));
    //     }
    //   } catch (e) {
    //     emit(AuthError(message: e.toString()));
    //   }
    // });

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
//Login with Email and Password
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
    // Toggle password visibility
    on<TogglePasswordVisibility>((event, emit) {
      emit(AuthPasswordVisibilityChanged(event.isPasswordVisible));
    });

    ///EXPp
    ///
    // on<CheckEmailVerificationStatus>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     final user = _authService.currentUser;
    //     if (user != null) {
    //       await user.reload(); // Reload user data
    //       if (user.emailVerified) {
    //         emit(AuthSuccess(user: user));
    //       } else {
    //         emit(AuthEmailNotVerified()); // Email not verified
    //       }
    //     } else {
    //       emit(AuthError(message: 'No user is currently signed in.'));
    //     }
    //   } catch (e) {
    //     emit(AuthError(message: 'Failed to check email verification status.'));
    //   }
    // });

    // on<CheckEmailVerificationStatus>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     final user = _authService.currentUser;
    //     if (user != null) {
    //       await user.reload();
    //       if (user.emailVerified) {
    //         emit(AuthSuccess(user: user));
    //       } else {
    //         emit(AuthEmailNotVerified());
    //       }
    //     } else {
    //       emit(AuthError(message: 'No user is currently signed in.'));
    //     }
    //   } catch (e) {
    //     emit(AuthError(message: 'Failed to check email verification status.'));
    //   }
    // });

    // Event handler for resending the email verification link
    // on<ResendEmailVerification>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     final user = _authService.currentUser;
    //     if (user != null) {
    //       await user.sendEmailVerification();
    //       emit(AuthEmailVerificationSent());
    //     } else {
    //       emit(AuthError(message: 'No user is currently signed in.'));
    //     }
    //   } catch (e) {
    //     emit(AuthError(message: 'Failed to re-send email verification.'));
    //   }
    // });
  }
}
