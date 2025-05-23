import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? leadingIconPath;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.leadingIconPath,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2E2E2E),
        prefixIcon: leadingIconPath != null
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            leadingIconPath!,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        )
            : null,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
