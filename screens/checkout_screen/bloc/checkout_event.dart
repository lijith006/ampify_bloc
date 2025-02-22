part of 'checkout_bloc.dart';

abstract class CheckoutEvent {}

class LoadAddress extends CheckoutEvent {}

class AddAddress extends CheckoutEvent {
  final String address;

  AddAddress(this.address);
}

class SelectedAddress extends CheckoutEvent {
  final String address;

  SelectedAddress(this.address);
}
