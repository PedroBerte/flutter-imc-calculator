import 'package:flutter/material.dart';
import 'package:imc_calc/components/button.dart';
import 'package:imc_calc/components/input.dart';
import 'package:imc_calc/controllers/auth_controller.dart';
import 'package:imc_calc/styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError;
  String? nameError;
  String? passwordError;
  bool isLoading = false;

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      emailError = null;
      nameError = null;
      passwordError = null;
    });

    bool hasError = false;

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      emailError = email.isEmpty ? 'Campo obrigatório' : null;
      nameError = name.isEmpty ? 'Campo obrigatório' : null;
      passwordError = password.isEmpty ? 'Campo obrigatório' : null;

      hasError = true;
    } else {
      if (!emailRegex.hasMatch(email)) {
        emailError = 'E-mail inválido';
        hasError = true;
      }
      if (!passwordRegex.hasMatch(password)) {
        passwordError = 'Mínimo 8 caracteres com letras e números';
        hasError = true;
      }
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthController().register(email, name, password);
      Navigator.pushReplacementNamed(context, '/login');
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
    _nameController.dispose();
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
              Text('Criar Conta', style: AppTextStyles.title),
              const SizedBox(height: 6),

              Text(
                'Cadastre-se para usar a calculadora de IMC',
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
                label: 'Nome completo',
                controller: _nameController,
                errorText: nameError,
                onChanged: (_) => setState(() => nameError = null),
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
                DefaultButton(content: 'Cadastrar', onPressed: _handleRegister),

              const SizedBox(height: 16),

              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text(
                  'Já tem conta? Faça login',
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
