import 'dart:convert';
import 'dart:io';

import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/screens/login_screen.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/home/home_screen.dart';
import 'package:ampify_bloc/widgets/custom_button.dart';
import 'package:ampify_bloc/widgets/custom_text-form-field.dart';
import 'package:ampify_bloc/widgets/validators_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _imageFile;
  String? _base64Image;
  //image pick
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _imageFile = File(pickedFile.path);
        _base64Image = base64Encode(bytes);
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Sign up',
            style: TextStyle(fontSize: 26),
          )),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: Container(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer glow/border
                                  Container(
                                    width: 190,
                                    height: 190,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              // ignore: deprecated_member_use
                                              Colors.black54.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Profile image
                                  CircleAvatar(
                                    radius: 90,
                                    backgroundColor: Colors.white,
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : const AssetImage(
                                                'assets/images/profile.png')
                                            as ImageProvider,
                                  ),
                                  // Edit icon overlay
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: _nameController,
                              labelText: 'Name',
                              validator: Validators.validateUsername,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              suffixIcon: const Icon(Icons.email_outlined),
                              controller: _emailController,
                              labelText: 'Email',
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                bool isPasswordVisible = false;
                                if (state is AuthPasswordVisibilityChanged) {
                                  isPasswordVisible = state.isPasswordVisible;
                                }
                                return CustomTextFormField(
                                  controller: _passwordController,
                                  obscureText: !isPasswordVisible,
                                  labelText: 'Password',
                                  validator: Validators.validatePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                          TogglePasswordVisibility(
                                              !isPasswordVisible));
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 50, 86, 116)),
                                  ),
                                ),
                              ],
                            ),
                            BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthLoading) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Signing up...')),
                                  );
                                }
                                if (state is AuthSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Signup Successful!')),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                }
                                if (state is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                }
                              },
                              child: Center(
                                child: CustomButton(
                                  label: 'SignUp',
                                  onTap: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      // --Trigger the sign-up event in the BLoC-
                                      if (_base64Image == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please select a profile image')),
                                        );
                                        return;
                                      }
                                      context.read<AuthBloc>().add(
                                            CreateUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              name: _nameController.text,
                                              base64Image: _base64Image,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Divider(thickness: 1),
                            const SizedBox(height: 5),
                            const Center(
                                child: Text('Or login with Google account')),
                            const SizedBox(height: 10),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                          'assets/images/google.png'),
                                    ),
                                  );
                                }
                                return Center(
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(LoginWithGoogle());
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                          'assets/images/google.png'),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
