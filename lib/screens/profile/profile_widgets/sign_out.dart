import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/widgets/custom_nav/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Sign Out',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<NavCubit>().updateIndex(0);
            context.read<AuthBloc>().add(Signout());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
