import 'package:flutter/material.dart';
import 'package:musicapp/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(colors: [
          Pallete.gradient1,
          Pallete.gradient2,
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Pallete.transparentColor,
          backgroundColor: Pallete.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
