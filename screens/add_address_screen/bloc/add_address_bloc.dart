import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'add_address_event.dart';
part 'add_address_state.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  AddAddressBloc() : super(AddAddressInitial()) {
    on<FetchLocationEvent>(_onFetchLocation);
  }

  Future<void> _onFetchLocation(
      FetchLocationEvent event, Emitter<AddAddressState> emit) async {
    emit(AddressLoading());

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        emit(AddressLoaded(
          country: place.country ?? '',
          fullName: '',
          mobile: '',
          address: place.name ?? '',
          area: place.subLocality ?? '',
          landmark: place.locality ?? '',
          pincode: place.postalCode ?? '',
          town: place.administrativeArea ?? '',
        ));
      } else {
        emit(AddressError("Address not found"));
      }
    } catch (e) {
      emit(AddressError("Failed to fetch location: $e"));
    }
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied. Please enable them in settings.");
    }

    return await Geolocator.getCurrentPosition();
  }
}
