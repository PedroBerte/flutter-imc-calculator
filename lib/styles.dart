import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4CAF50);
  static const background = Color(0xFFF5F5F5);
  static const text = Color(0xFF212121);
  static const warning = Color(0xFFFFC107);
}

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
