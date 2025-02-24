import 'package:ampify_bloc/screens/checkout_screen/checkoutService.dart';
import 'package:bloc/bloc.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final AddressService addressService;

  CheckoutBloc(this.addressService) : super(CheckoutState(addresses: [])) {
    on<CheckoutEvent>((event, emit) async {
      final addresses = await addressService.fetchAddresses();
      emit(CheckoutState(
          addresses: addresses, selectedAddress: state.selectedAddress));
    });

    on<AddAddress>((event, emit) async {
      await addressService.addAddress(event.address);
      final updatedAddresses = await addressService.fetchAddresses();
      emit(CheckoutState(
          addresses: updatedAddresses, selectedAddress: state.selectedAddress));
    });

    on<SelectAddress>((event, emit) {
      emit(CheckoutState(
          addresses: state.addresses, selectedAddress: event.address));
    });
  }
}
