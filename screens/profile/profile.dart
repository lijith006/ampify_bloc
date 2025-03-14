// import 'dart:convert';

// import 'package:ampify_bloc/common/app_colors.dart';
// import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});

//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }

// class _MyProfileState extends State<MyProfile> {
//   // final TextEditingController _nameController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(LoadProfile()); // Load profile data
//   }

//   // void _showEditDialog(Map<String, dynamic> userProfile) {
//   //   _nameController.text = userProfile['name'] ?? '';

//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text('Edit Profile'),
//   //       content: TextField(
//   //         controller: _nameController,
//   //         decoration: const InputDecoration(labelText: 'Name'),
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             child: const Text('Cancel')),
//   //         TextButton(
//   //             onPressed: () {
//   //               context.read<ProfileBloc>().add(
//   //                   UpdateProfile(updates: {'name': _nameController.text}));
//   //               Navigator.pop(context);
//   //             },
//   //             child: const Text('Save'))
//   //       ],
//   //     ),
//   //   );
//   // }

//   // void _confirmDeleteAccount() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text('Delete Account'),
//   //       content: const Text(
//   //           'Are you sure you want to delete your account? This action is irreversible.'),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text('Cancel'),
//   //         ),
//   //         TextButton(
//   //           onPressed: () {
//   //             context.read<ProfileBloc>().add(DeleteAccount());
//   //             Navigator.pop(context);
//   //           },
//   //           child: const Text('Delete', style: TextStyle(color: Colors.red)),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('M y   P r o f i l e'),
//       ),
//       body: BlocBuilder<ProfileBloc, ProfileState>(
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (state is ProfileLoaded) {
//             final userProfile = state.userProfile;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: userProfile['profileImage'] != null
//                           ? (userProfile['profileImage'].startsWith('http')
//                               ? NetworkImage(userProfile['profileImage'])
//                               : MemoryImage(
//                                   base64Decode(userProfile['profileImage'])))
//                           : const AssetImage('assets/images/profile.png')
//                               as ImageProvider,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       userProfile['name'] ?? 'Unknown',
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       userProfile['email'] ?? 'No email',
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else if (state is ProfileError) {
//             return Center(
//               child: Text(state.message),
//             );
//           } else {
//             return const Center(
//               child: Text('Unknown state'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//*********************************************************** */
import 'dart:convert';

import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/order_tracking_screen/track_my_orders.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/about_screen.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/privacy_policy_screen.dart';
import 'package:ampify_bloc/screens/profile/profile_screens/user_agreement_screen.dart';
import 'package:ampify_bloc/widgets/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile()); // Load profile data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                    //Text('M y   P r o f i l e'),
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
                    Expanded(
                        child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: const Text('Track My Orders'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllOrdersScreen(),
                                ));
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
                                  builder: (context) => PrivacyPolicyScreen()),
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
                                  builder: (context) => UserAgreementScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout_outlined),
                          title: const Text('Log out'),
                          onTap: () {
                            // Log out
                            showSignOutDialog(context);
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
    );
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
                Navigator.pop(context);
                context.read<ProfileBloc>().add(LogoutUser()); //  logout event
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Sign Out',
                style: AppWidget.whitelightTextFieldStyle(),
              ),
            ),
          ],
        );
      },
    );
  }
}
