import 'package:flutter/material.dart';
import 'package:imc_calc/styles.dart';

class DefaultButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  final bool enabled;

  const DefaultButton({
    super.key,
    required this.content,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: const TextStyle(
          color: AppColors.background,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(content),
    );
  }
}
