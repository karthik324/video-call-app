import 'package:flutter/material.dart';
import 'package:video_call_app/core/app_colors.dart';
import 'package:video_call_app/core/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.obscure,
  });

  final IconData icon;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
            width: 0.1,
            style: BorderStyle.none,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.borderColor,
        ),
      ),
    );
  }
}
