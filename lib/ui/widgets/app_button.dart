import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: 5,
          ),
        ),
      ),
    );
  }
}
