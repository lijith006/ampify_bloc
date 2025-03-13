// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
// import 'package:ampify_bloc/screens/checkout_screen/addresstService.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
//   final AddressService addressService;

//   CheckoutBloc(this.addressService) : super(CheckoutState()) {
//     on<LoadAddresses>((event, emit) async {
//       //  loading state
//       emit(state.copyWith(isLoading: true));
//       try {
//         final addresses = await addressService.fetchAddresses();
//         emit(state.copyWith(addresses: addresses, isLoading: false));
//       } catch (e) {
//         // Hide loading state if failed
//         emit(state.copyWith(isLoading: false));
//       }
//     });
//     on<AddAddress>((event, emit) async {
//       await addressService.addAddress(event.address);
//       add(LoadAddresses());
//     });

//     on<SelectAddress>((event, emit) {
//       emit(state.copyWith(selectedAddress: event.selectedAddress));
//     });

//     on<EditAddress>((event, emit) async {
//       await addressService.updateAddress(event.id, event.newAddress);
//       add(LoadAddresses());
//     });

//     on<DeleteAddress>((event, emit) async {
//       await addressService.deleteAddress(event.id);
//       add(LoadAddresses());
//     });
//   }
// }
//***********************************MARCH 12 ********************* */
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
import 'package:ampify_bloc/screens/checkout_screen/addresstService.dart';
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
