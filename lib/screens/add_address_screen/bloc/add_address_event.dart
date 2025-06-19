part of 'add_address_bloc.dart';

abstract class AddAddressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchLocationEvent extends AddAddressEvent {}
