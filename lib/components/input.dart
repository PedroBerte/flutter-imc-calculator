import 'package:flutter/material.dart';
import 'package:imc_calc/styles.dart';

class DefaultInput extends StatelessWidget {
  final String label;
  final String? errorText;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool password;

  const DefaultInput({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.hint = "",
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.password = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      obscureText: password,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        labelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
      ),
    );
  }
}
