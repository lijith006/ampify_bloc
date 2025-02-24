import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:ampify_bloc/widgets/validators_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController countryController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

//Location
//Fetch user's location

  Future<void> fetchAndSetAddress() async {
    Position? position = await _determinePosition();
    if (position != null) {
      String address =
          await getAddressFromLatLng(position.latitude, position.longitude);
      setState(() {
        addressController.text = address;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permission denied or service diabled')));
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks[0];
      return '${place.name},${place.street},${place.subLocality},${place.locality}, ${place.country}, ${place.postalCode}';
    } catch (e) {
      return 'Address not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add New Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Country
              CustomTextFormField(
                  controller: countryController, labelText: 'Country'),

              // Full Name
              CustomTextFormField(
                  controller: fullNameController, labelText: 'Full name'),
//Mobile number
              CustomTextFormField(
                controller: mobileController,
                labelText: 'Mobile number',
                keyboardType: TextInputType.phone,
                validator: Validators.validateMobileNumber,
              ),

              const SizedBox(
                height: 20,
              ),

              //USE My Location
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
                label: const Text(
                  "Use My Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                onPressed: () async {
                  await fetchAndSetAddress();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    backgroundColor: Colors.teal),
              ),

              const SizedBox(
                height: 10,
              ),

              //Address Flat/House/Company
              CustomTextFormField(
                  controller: addressController,
                  labelText: 'Flat, House No, Company, Apartment'),
              //Area,Street

              CustomTextFormField(
                  controller: areaController,
                  labelText: 'Area, Street, Village'),

              //Landmark
              CustomTextFormField(
                  controller: landmarkController, labelText: 'Landmark'),

              //Pincode
              CustomTextFormField(
                  controller: pincodeController, labelText: 'Pincode'),
              //Town/City
              CustomTextFormField(
                  controller: townController, labelText: 'Town/City'),

              //-------------------------------------------------------------------------------------
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  label: 'Save Address',
                  onTap: () {
                    if (_addressController.text.isNotEmpty) {
                      context
                          .read<CheckoutBloc>()
                          .add(AddAddress(_addressController.text));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
