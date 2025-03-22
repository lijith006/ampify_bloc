import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/add_address_screen/bloc/add_address_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:ampify_bloc/widgets/validators_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  // final TextEditingController countryController = TextEditingController();
  final TextEditingController countryController =
      TextEditingController(text: 'India');

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController areaController = TextEditingController();

  final TextEditingController landmarkController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  final TextEditingController townController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAddressBloc(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Add New Address'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocConsumer<AddAddressBloc, AddAddressState>(
              listener: (context, state) {
                if (state is AddressLoaded) {
                  countryController.text = state.country;
                  addressController.text = state.address;
                  areaController.text = state.area;
                  landmarkController.text = state.landmark;
                  pincodeController.text = state.pincode;
                  townController.text = state.town;
                } else if (state is AddressError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Country
                    CustomTextFormField(
                      controller: countryController,
                      readOnly: true,
                      labelText: 'Country',
                      validator: (value) =>
                          Validators.validateRequired(value, 'Country'),
                    ),

                    // Full Name
                    CustomTextFormField(
                      controller: fullNameController,
                      labelText: 'Full name',
                      validator: (value) => Validators.validateUsername(value),
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
                      icon: state is AddressLoading
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
                        state is AddressLoading
                            ? 'Fetching Location...'
                            : "Use My Location",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      onPressed: state is AddressLoading
                          ? null
                          : () async => context
                              .read<AddAddressBloc>()
                              .add(FetchLocationEvent()),
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
                      keyboardType: TextInputType.number,
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
                          if (_validateForm()) {
                            String newAddress =
                                "${fullNameController.text}, ${addressController.text}, ${areaController.text}, ${landmarkController.text}, ${townController.text}, ${pincodeController.text}, ${countryController.text}";

                            if (newAddress.isNotEmpty) {
                              context
                                  .read<CheckoutBloc>()
                                  .add(AddAddress(newAddress));
                              Navigator.pop(context);
                            }
                          }
                        })
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (countryController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty ||
        areaController.text.isEmpty ||
        landmarkController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        townController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please fill in all required fields')),
      );
      return false;
    }
    return true;
  }
}
