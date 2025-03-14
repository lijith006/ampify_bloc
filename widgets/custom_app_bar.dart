import 'package:ampify_bloc/common/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    required this.title,
    this.backgroundColor = AppColors.backgroundColor,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      actions: actions,
      leading: leading,
    );
  }

  // Set the preferred size of the app bar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
