class CheckoutState {
  final List<Map<String, dynamic>> addresses;
  final String? selectedAddress;
  final bool isLoading;

  CheckoutState(
      {this.addresses = const [],
      this.selectedAddress,
      this.isLoading = false});

  CheckoutState copyWith(
      {List<Map<String, dynamic>>? addresses,
      String? selectedAddress,
      bool? isLoading}) {
    return CheckoutState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddressErrorState extends CheckoutState {
  final String message;

  AddressErrorState(this.message);

  @override
  String toString() => 'AddressErrorState: $message';
}
