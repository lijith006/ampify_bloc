import 'dart:convert';

import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/bloc/auth_state.dart';
import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/chat_screen/chat_bloc/bloc/chat_bloc.dart';
import 'package:ampify_bloc/screens/chat_screen/chat_screen/chat_screen.dart';
import 'package:ampify_bloc/screens/chat_screen/service/chat_service.dart';
import 'package:ampify_bloc/screens/checkout_screen/select_address_screen.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/my_orders_screen.dart';
import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/about_screen.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/privacy_policy_screen.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/user_agreement_screen.dart';
import 'package:ampify_bloc/screens/profile/profile_widgets/sign_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => current is AuthInitial,
            listener: (context, state) {
              if (state is AuthInitial) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/profile_loading.json',
                  width: 250,
                ),
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.local_shipping),
                            title: const Text('My Orders'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => OrderBloc(
                                          firestore:
                                              FirebaseFirestore.instance),
                                      child: const AllOrdersScreen(),
                                    ),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text('Manage Addresses'),
                            onTap: () {
                              // Navigate to About Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectAddressScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text('About Us'),
                            onTap: () {
                              // Navigate to About Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text('Privacy Policy'),
                            onTap: () {
                              // Navigate to Privacy Policy Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PrivacyPolicyScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.article),
                            title: const Text('User Agreement'),
                            onTap: () {
                              // Navigate to User Agreement Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserAgreementScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.chat),
                            title: const Text('Chat with Admin'),
                            onTap: () {
                              final currentUserId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final chatId = '${currentUserId}_admin';
                              print('Opening chat room: $chatId');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: chatId,
                                    currentUserId: currentUserId,
                                    chatBloc: ChatBloc(ChatService()),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout_outlined),
                            title: const Text('Log out'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const SignOutDialog(),
                              );
                            },
                          ),
                        ],
                      ))
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
      ),
    );
  }
}
