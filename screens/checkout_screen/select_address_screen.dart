import 'package:ampify_bloc/screens/checkout_screen/add_new_address_screen.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (BuildContext context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: state.addresses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.addresses[index]),
                      trailing: Radio(
                          value: state.addresses[index],
                          groupValue: state.selectedAddress,
                          onChanged: (value) {
                            context
                                .read<CheckoutBloc>()
                                .add(SelectAddress(value as String));
                            Navigator.pop(context);
                          }),
                    );
                  },
                )),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewAddressScreen())),
                  child: Text("Add New Address"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
