part of 'checkout_bloc.dart';

abstract class CheckoutEvent {}

class LoadAddress extends CheckoutEvent {}

class AddAddress extends CheckoutEvent {
  final String address;

  AddAddress(this.address);
}

class SelectAddress extends CheckoutEvent {
  final String address;

  SelectAddress(this.address);
}
