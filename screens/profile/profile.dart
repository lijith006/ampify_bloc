import 'dart:convert';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile()); // Load profile data
  }

  void _showEditDialog(Map<String, dynamic> userProfile) {
    _nameController.text = userProfile['name'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                context.read<ProfileBloc>().add(
                    UpdateProfile(updates: {'name': _nameController.text}));
                Navigator.pop(context);
              },
              child: const Text('Save'))
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action is irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(DeleteAccount());
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('M y   P r o f i l e'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            final userProfile = state.userProfile;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userProfile['profileImage'] != null
                          ? (userProfile['profileImage'].startsWith('http')
                              ? NetworkImage(userProfile['profileImage'])
                              : MemoryImage(
                                  base64Decode(userProfile['profileImage'])))
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      userProfile['name'] ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userProfile['email'] ?? 'No email',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // ElevatedButton(
                    //   onPressed: () => _showEditDialog(userProfile),
                    //   child: const Text('Edit Profile'),
                    // ),
                    // const SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: _confirmDeleteAccount,
                    //   style:
                    //       ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    //   child: const Text('Delete Account'),
                    // ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
    );
  }
}
