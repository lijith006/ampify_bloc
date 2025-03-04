// import 'package:ampify_bloc/screens/checkout_screen/checkoutService.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'checkout_event.dart';
// part 'checkout_state.dart';

// class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
//   final AddressService addressService;

//   CheckoutBloc(this.addressService) : super(CheckoutState(addresses: [])) {
//     on<CheckoutEvent>((event, emit) async {
//       final addresses = await addressService.fetchAddresses();
//       emit(CheckoutState(
//           addresses: addresses, selectedAddress: state.selectedAddress));
//     });

//     on<AddAddress>((event, emit) async {
//       await addressService.addAddress(event.address);
//       final updatedAddresses = await addressService.fetchAddresses();
//       emit(CheckoutState(
//           addresses: updatedAddresses, selectedAddress: state.selectedAddress));
//     });

//     on<SelectAddress>((event, emit) {
//       emit(CheckoutState(
//           addresses: state.addresses, selectedAddress: event.address));
//     });
//   }
// }
//******************************************************* */

// import 'package:ampify_bloc/screens/checkout_screen/checkoutService.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
//   final AddressService addressService;

//   CheckoutBloc(this.addressService) : super(const CheckoutState()) {
//     // on<CheckoutEvent>((event, emit) async {
//     //   final addresses = await addressService.fetchAddresses();
//     //   emit(CheckoutState(
//     //       addresses: addresses, selectedAddress: state.selectedAddress));
//     // });

//     on<LoadAddresses>((event, emit) async {
//       emit(state.copyWith(isLoading: true)); // Show loading state
//       try {
//         final addresses = await addressService.fetchAddresses();
//         emit(state.copyWith(addresses: addresses, isLoading: false));
//       } catch (e) {
//         emit(state.copyWith(isLoading: false)); // Hide loading state if failed
//       }
//     });

//     on<AddAddress>((event, emit) async {
//       await addressService.addAddress(event.address); //save to firestore
//       final updatedAddresses = List<String>.from(state.addresses)
//         ..add(event.address);
//       emit(state.copyWith(addresses: updatedAddresses));
//     });

//     on<SelectAddress>((event, emit) {
//       emit(state.copyWith(selectedAddress: event.selectedAddress));
//     });
//   }
// }

//********************************************************** */

import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkoutService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final AddressService addressService;

  CheckoutBloc(this.addressService) : super(CheckoutState()) {
    on<LoadAddresses>((event, emit) async {
      //  loading state
      emit(state.copyWith(isLoading: true));
      try {
        final addresses = await addressService.fetchAddresses();
        emit(state.copyWith(addresses: addresses, isLoading: false));
      } catch (e) {
        // Hide loading state if failed
        emit(state.copyWith(isLoading: false));
      }
    });
    on<AddAddress>((event, emit) async {
      await addressService.addAddress(event.address);
      add(LoadAddresses());
    });

    on<SelectAddress>((event, emit) {
      emit(state.copyWith(selectedAddress: event.selectedAddress));
    });

    on<EditAddress>((event, emit) async {
      await addressService.updateAddress(event.id, event.newAddress);
      add(LoadAddresses());
    });

    on<DeleteAddress>((event, emit) async {
      await addressService.deleteAddress(event.id);
      add(LoadAddresses());
    });
  }
}
