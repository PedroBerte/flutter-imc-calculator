import 'package:flutter/material.dart';
import 'package:imc_calc/models/user_model.dart';
import 'package:imc_calc/utils/db_helper.dart';

Future<UserModel?> handleGetAuth(BuildContext context) async {
  final Map<String, dynamic>? user =
      await DatabaseHelper.instance.getLoggedInUser();

  if (user != null) {
    final UserModel response = UserModel(
      name: user[DatabaseHelper.columnName] as String,
      userId: user[DatabaseHelper.columnUserId],
      email: user[DatabaseHelper.columnEmail] as String,
      password: user[DatabaseHelper.columnPassword] as String,
    );

    return response;
  } else {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    return null;
  }
}
