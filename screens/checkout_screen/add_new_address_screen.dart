// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
// import 'package:ampify_bloc/widgets/custom_button.dart';
// import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
// import 'package:ampify_bloc/widgets/validators_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class AddNewAddressScreen extends StatefulWidget {
//   @override
//   State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
// }

// class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController areaController = TextEditingController();
//   final TextEditingController landmarkController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//   final TextEditingController townController = TextEditingController();
//   // final TextEditingController _addressController = TextEditingController();

// //Location

//   bool isLoading = false;
// //Fetch user's location

//   Future<void> fetchAndSetAddress() async {
//     setState(() {
//       isLoading = true;
//     });
//     Position? position = await _determinePosition();
//     if (position != null) {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];

//         // String address =
//         //     await getAddressFromLatLng(position.latitude, position.longitude);
//         setState(() {
//           // addressController.text = address;
//           addressController.text = place.name ?? ''; // Flat/House No
//           areaController.text = place.street ?? ''; // Street/Area
//           landmarkController.text = place.subLocality ?? ''; // Landmark
//           townController.text = place.locality ?? ''; // Town/City
//           countryController.text = place.country ?? ''; // Country
//           pincodeController.text = place.postalCode ?? ''; // Pincode
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permission denied or service diabled')));
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<Position?> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return null;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return null;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return null;
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('Add New Address'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //Country
//               CustomTextFormField(
//                   controller: countryController, labelText: 'Country'),

//               // Full Name
//               CustomTextFormField(
//                   controller: fullNameController, labelText: 'Full name'),
// //Mobile number
//               CustomTextFormField(
//                 controller: mobileController,
//                 labelText: 'Mobile number',
//                 keyboardType: TextInputType.phone,
//                 validator: Validators.validateMobileNumber,
//               ),

//               const SizedBox(
//                 height: 20,
//               ),

//               //USE My Location
//               ElevatedButton.icon(
//                 icon: isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Icon(
//                         Icons.my_location,
//                         color: Colors.white,
//                       ),
//                 label: Text(
//                   isLoading ? 'Fetching Location...' : "Use My Location",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white, // Text color
//                   ),
//                 ),
//                 onPressed: isLoading
//                     ? null
//                     : () async {
//                         await fetchAndSetAddress();
//                       },
//                 style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 5,
//                     shadowColor: Colors.black54,
//                     backgroundColor: Colors.teal),
//               ),

//               const SizedBox(
//                 height: 10,
//               ),

//               //Address Flat/House/Company
//               CustomTextFormField(
//                   controller: addressController,
//                   labelText: 'Flat, House No, Company, Apartment'),
//               //Area,Street

//               CustomTextFormField(
//                   controller: areaController,
//                   labelText: 'Area, Street, Village'),

//               //Landmark
//               CustomTextFormField(
//                   controller: landmarkController, labelText: 'Landmark'),

//               //Pincode
//               CustomTextFormField(
//                   controller: pincodeController, labelText: 'Pincode'),
//               //Town/City
//               CustomTextFormField(
//                   controller: townController, labelText: 'Town/City'),

//               //-------------------------------------------------------------------------------------
//               const SizedBox(
//                 height: 20,
//               ),
//               CustomButton(
//                   label: 'Save Address',
//                   onTap: () {
//                     String newAddress =
//                         "${fullNameController.text}, ${addressController.text}, ${areaController.text}, ${landmarkController.text}, ${townController.text}, ${pincodeController.text}, ${countryController.text}";

//                     if (newAddress.isNotEmpty) {
//                       context.read<CheckoutBloc>().add(AddAddress(newAddress));
//                       Navigator.pop(context);
//                       // if (_addressController.text.isNotEmpty) {
//                       //   context
//                       //       .read<CheckoutBloc>()
//                       //       .add(AddAddress(_addressController.text));
//                       // }
//                     }
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//***************************************************** */

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
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
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController townController = TextEditingController();

//Location

  bool isLoading = false;

//Fetch user's location

  Future<void> fetchAndSetAddress() async {
    setState(() => isLoading = true);

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = place.thoroughfare ??
            place.street ??
            place.subLocality ??
            place.locality ??
            "Unknown Address";

        print("Formatted Address: $address");

        bool isPlusCode(String? value) {
          return value != null &&
              RegExp(r'^[2-9CFGHJMPQRV]{4,}\+[2-9CFGHJMPQRV]{2,}$')
                  .hasMatch(value);
        }

        setState(() {
          // addressController.text = place.street?.isNotEmpty == true
          //     ? place.street!
          //     : place.name ?? '';
          addressController.text =
              isPlusCode(place.name) ? '' : place.name ?? '';
          areaController.text = place.subLocality?.isNotEmpty == true
              ? place.subLocality!
              : place.locality ?? '';
          landmarkController.text = place.locality ?? '';
          townController.text =
              place.administrativeArea ?? place.locality ?? '';
          countryController.text = place.country ?? '';
          pincodeController.text = place.postalCode ?? '';
        });
      } else {
        throw Exception("Address not found");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    } finally {
      setState(() => isLoading = false);
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
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition();
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
                controller: countryController,
                labelText: 'Country',
                validator: (value) =>
                    Validators.validateRequired(value, 'Country'),
              ),

              // Full Name
              CustomTextFormField(
                controller: fullNameController,
                labelText: 'Full name',
                validator: (value) =>
                    Validators.validateRequired(value, 'Full Name'),
              ),
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
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                label: Text(
                  isLoading ? 'Fetching Location...' : "Use My Location",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
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
                labelText: 'Flat, House No, Company, Apartment',
                validator: (value) =>
                    Validators.validateRequired(value, 'Address'),
              ),
              //Area,Street

              CustomTextFormField(
                controller: areaController,
                labelText: 'Area, Street, Village',
                validator: (value) =>
                    Validators.validateRequired(value, 'Area/Street'),
              ),

              //Landmark
              CustomTextFormField(
                controller: landmarkController,
                labelText: 'Landmark',
                validator: (value) =>
                    Validators.validateRequired(value, 'Landmark'),
              ),

              //Pincode
              CustomTextFormField(
                controller: pincodeController,
                labelText: 'Pincode',
                validator: Validators.validatePincode,
              ),
              //Town/City
              CustomTextFormField(
                controller: townController,
                labelText: 'Town/City',
                validator: (value) =>
                    Validators.validateRequired(value, 'Town/City'),
              ),

              //-------------------------------------------------------------------------------------
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  label: 'Save Address',
                  onTap: () {
                    // final formState = _formKey.currentState;
                    // if (formState != null && formState.validate()) {
                    // if (_formKey.currentState!.validate()) {
                    String newAddress =
                        "${fullNameController.text}, ${addressController.text}, ${areaController.text}, ${landmarkController.text}, ${townController.text}, ${pincodeController.text}, ${countryController.text}";

                    if (newAddress.isNotEmpty) {
                      context.read<CheckoutBloc>().add(AddAddress(newAddress));
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
