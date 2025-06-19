part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class LogoutUser extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> updates;

  UpdateProfile({required this.updates});
}

class DeleteAccount extends ProfileEvent {}
