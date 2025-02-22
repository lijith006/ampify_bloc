part of 'checkout_bloc.dart';

class CheckoutState {
  final List<String> addresses;
  final String? selectedAddress;

  const CheckoutState({required this.addresses, this.selectedAddress});
}
