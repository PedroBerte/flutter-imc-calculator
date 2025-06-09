import 'package:flutter/material.dart';
import 'package:imc_calc/views/imc_calculator_screen.dart';
import 'package:imc_calc/views/login_screen.dart';
import 'package:imc_calc/views/register_screen.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/imc-calculator',
      theme: ThemeData(fontFamily: 'Poppins', useMaterial3: true),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/imc-calculator': (context) => ImcCalculatorScreen(),
      },
    );
  }
}
