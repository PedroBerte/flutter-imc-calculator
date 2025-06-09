import 'package:flutter/material.dart';
import 'package:imc_calc/components/button.dart';
import 'package:imc_calc/components/input.dart';
import 'package:imc_calc/controllers/auth_controller.dart';
import 'package:imc_calc/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool hasError = false;

    if (email.isEmpty || password.isEmpty) {
      if (email.isEmpty) emailError = 'Preencha o e-mail.';
      if (password.isEmpty) passwordError = 'Preencha a senha.';
      hasError = true;
    } else {
      if (!emailRegex.hasMatch(email)) {
        emailError = 'E-mail inválido.';
        hasError = true;
      }

      if (!passwordRegex.hasMatch(password)) {
        passwordError =
            'Senha inválida. Mínimo 8 caracteres, letras e números.';
        hasError = true;
      }
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthController().login(email, password);
      Navigator.pushReplacementNamed(context, '/imc-calculator');
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 12),
              Text('Calculadora de IMC', style: AppTextStyles.title),

              const SizedBox(height: 8),
              Text(
                'Realize o login para utilizar a calculadora.',
                style: AppTextStyles.subtitle,
              ),

              const SizedBox(height: 24),

              DefaultInput(
                label: 'E-mail',
                controller: _emailController,
                errorText: emailError,
                onChanged: (_) => setState(() => emailError = null),
              ),

              const SizedBox(height: 16),

              DefaultInput(
                label: 'Senha',
                controller: _passwordController,
                errorText: passwordError,
                onChanged: (_) => setState(() => passwordError = null),
                password: true,
              ),

              const SizedBox(height: 24),

              if (isLoading)
                const CircularProgressIndicator(strokeWidth: 3)
              else
                DefaultButton(content: 'Entrar', onPressed: _handleLogin),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  'Não tem conta? Cadastre-se aqui',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
