import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onTap,
      this.readOnly=false,
      this.isObscuredText = false});
  final String hintText;
  final TextEditingController? controller;
  final bool isObscuredText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,

readOnly: readOnly,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      controller: controller,
      obscureText: isObscuredText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
