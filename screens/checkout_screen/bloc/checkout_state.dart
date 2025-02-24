// part of 'checkout_bloc.dart';

// class CheckoutState {
//   final List<String> addresses;
//   final String? selectedAddress;

//   const CheckoutState({required this.addresses, this.selectedAddress});
// }
//************************************************* */
// part of 'checkout_bloc.dart';

// class CheckoutState extends Equatable {
//   final List<String> addresses;
//   final String? selectedAddress;
//   final bool isLoading;

//   const CheckoutState(
//       {this.addresses = const [],
//       this.selectedAddress,
//       this.isLoading = false});

//   CheckoutState copyWith(
//       {List<String>? addresses, String? selectedAddress, bool? isLoading}) {
//     return CheckoutState(
//       addresses: addresses ?? this.addresses,
//       selectedAddress: selectedAddress ?? this.selectedAddress,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }

//   @override
//   List<Object?> get props => [addresses, selectedAddress, isLoading];
// }
//******************************************************* */
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
