import 'package:ampify_bloc/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final Widget? prefixicon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.prefixicon,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          filled: true,
          // fillColor: Colors.grey[200],
          // fillColor: Color(0XFFe1d5c9),
          fillColor: const Color.fromARGB(255, 240, 237, 235),

          // border: InputBorder.none,

          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25), // Modern rounded corners
              borderSide:
                  const BorderSide(color: AppColors.border, width: 1.0)),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: AppColors.outLineColor,
              width: 1.5,
            ),
          ), // Define the error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.red, // Error border color
              width: 1.5, // Error border width
            ),
          ),
          suffixIcon: suffixIcon,
          // prefixIcon: prefixicon,
          prefixIcon: prefixicon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: prefixicon,
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
