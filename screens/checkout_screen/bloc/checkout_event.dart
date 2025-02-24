// part of 'checkout_bloc.dart';

// abstract class CheckoutEvent {}

// class LoadAddress extends CheckoutEvent {}

// class AddAddress extends CheckoutEvent {
//   final String address;

//   AddAddress(this.address);
// }

// class SelectAddress extends CheckoutEvent {
//   final String address;

//   SelectAddress(this.address);
// }

//******************************************** */
// part of 'checkout_bloc.dart';

// abstract class CheckoutEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoadAddresses extends CheckoutEvent {}

// class AddAddress extends CheckoutEvent {
//   final String address;

//   AddAddress(this.address);
//   @override
//   List<Object> get props => [address];
// }

// class SelectAddress extends CheckoutEvent {
//   final String selectedAddress;

//   SelectAddress(this.selectedAddress);
//   @override
//   List<Object> get props => [selectedAddress];
// }

//************************************************** */

abstract class CheckoutEvent {}

class LoadAddresses extends CheckoutEvent {}

class AddAddress extends CheckoutEvent {
  final String address;
  AddAddress(this.address);
}

class SelectAddress extends CheckoutEvent {
  final String selectedAddress;
  SelectAddress(this.selectedAddress);
}

class EditAddress extends CheckoutEvent {
  final String id;
  final String newAddress;
  EditAddress(this.id, this.newAddress);
}

class DeleteAddress extends CheckoutEvent {
  final String id;
  DeleteAddress(this.id);
}
