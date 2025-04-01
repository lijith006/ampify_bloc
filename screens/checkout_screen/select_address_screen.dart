import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/add_address_screen/add_new_address_screen.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_state.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:ampify_bloc/widgets/custom_orange_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Select Address'),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is AddressErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (BuildContext context, state) {
          // Show loader while fetching
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index]['address'];
                      final id = state.addresses[index]['id'];
                      return Card(
                        color: AppColors.backgroundColor,
                        child: ListTile(
                          title: Text(
                            address,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  TextEditingController controller =
                                      TextEditingController(text: address);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Edit Address"),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                            hintText: "Enter new address"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<CheckoutBloc>()
                                                .add(EditAddress(id, address));
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context
                                      .read<CheckoutBloc>()
                                      .add(DeleteAddress(id));
                                },
                              ),
                              Radio(
                                value: address,
                                groupValue: state.selectedAddress,
                                onChanged: (value) {
                                  context
                                      .read<CheckoutBloc>()
                                      .add(SelectAddress(value as String));
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CustomOrangeButton(
                    width: 300,
                    text: 'Add New Address',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewAddressScreen()),
                      );
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
