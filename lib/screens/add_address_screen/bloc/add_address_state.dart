part of 'add_address_bloc.dart';

abstract class AddAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddAddressInitial extends AddAddressState {}

class AddressLoading extends AddAddressState {}

class AddressLoaded extends AddAddressState {
  final String country;
  final String fullName;
  final String mobile;
  final String address;
  final String area;
  final String landmark;
  final String pincode;
  final String town;

  AddressLoaded({
    required this.country,
    required this.fullName,
    required this.mobile,
    required this.address,
    required this.area,
    required this.landmark,
    required this.pincode,
    required this.town,
  });

  @override
  List<Object?> get props =>
      [country, fullName, mobile, address, area, landmark, pincode, town];
}

class AddressError extends AddAddressState {
  final String message;
  AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
