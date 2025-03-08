// part of 'profile_bloc.dart';

// abstract class ProfileState {}

// class ProfileInitial extends ProfileState {}

// class ProfileLoading extends ProfileState {}

// class ProfileLoaded extends ProfileState {
//   final Map<String, dynamic> userProfile;

//   ProfileLoaded({required this.userProfile});
// }

// class ProfileUpdated extends ProfileState {}

// class ProfileDeleted extends ProfileState {}

// class ProfileError extends ProfileState {
//   final String message;

//   ProfileError(this.message);
// }
//*********************************************** */
part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoggedOut extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userProfile;

  ProfileLoaded({required this.userProfile});
}

class ProfileUpdated extends ProfileState {}

class ProfileDeleted extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
