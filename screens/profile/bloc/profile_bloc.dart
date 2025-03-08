// import 'package:ampify_bloc/screens/profile/profile_service.dart';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// part 'profile_event.dart';
// part 'profile_state.dart';

// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final ProfileService _profileService;
//   ProfileBloc(this._profileService) : super(ProfileInitial()) {
//     on<LoadProfile>(_onLoadProfile);
//     on<UpdateProfile>(_onUpdateProfile);
//     on<DeleteAccount>(_onDeleteAccount);
//   }

//   Future<void> _onLoadProfile(
//       LoadProfile event, Emitter<ProfileState> emit) async {
//     emit(ProfileLoading());
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(ProfileError('User not logged in'));
//         return;
//       }

//       final userProfile = await _profileService.getUserProfile(userId);
//       emit(ProfileLoaded(userProfile: userProfile));
//     } catch (e) {
//       emit(ProfileError('Failed to load profile: ${e.toString()}'));
//     }
//   }

//   Future<void> _onUpdateProfile(
//       UpdateProfile event, Emitter<ProfileState> emit) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(ProfileError('User not logged in'));
//         return;
//       }

//       await _profileService.updateProfile(userId, event.updates);
//       emit(ProfileUpdated()); // Notify UI
//       add(LoadProfile()); // Reload updated profile
//     } catch (e) {
//       emit(ProfileError('Failed to update profile'));
//     }
//   }

//   Future<void> _onDeleteAccount(
//       DeleteAccount event, Emitter<ProfileState> emit) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) {
//         emit(ProfileError('User not logged in'));
//         return;
//       }

//       await _profileService.deleteAccount(userId);
//       emit(ProfileDeleted());
//     } catch (e) {
//       emit(ProfileError('Failed to delete account'));
//     }
//   }
// }
//****************************************************** */
import 'package:ampify_bloc/screens/profile/profile_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;
  ProfileBloc(this._profileService) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteAccount>(_onDeleteAccount);
    on<LogoutUser>(_onLogoutUser);
  }
  Future<void> _onLogoutUser(
      LogoutUser event, Emitter<ProfileState> emit) async {
    try {
      await _profileService.logout(); // Call logout from ProfileService
      emit(ProfileLoggedOut()); // Notify UI to navigate to Login Screen
    } catch (e) {
      emit(ProfileError('Failed to log out'));
    }
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      final userProfile = await _profileService.getUserProfile(userId);
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      await _profileService.updateProfile(userId, event.updates);
      emit(ProfileUpdated()); // Notify UI
      add(LoadProfile()); // Reload updated profile
    } catch (e) {
      emit(ProfileError('Failed to update profile'));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<ProfileState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      await _profileService.deleteAccount(userId);
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError('Failed to delete account'));
    }
  }
}
