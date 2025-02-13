import 'package:ampify_bloc/common/app_colors.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const CustomActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: padding,
      ),
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, color: AppColors.textcolorCommmonGrey)
          : const SizedBox.shrink(),
      label: Text(
        label,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textcolorCommmonGrey),
      ),
    );
  }
}
