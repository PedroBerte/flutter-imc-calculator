import 'package:flutter/material.dart';
import 'package:imc_calc/components/button.dart';
import 'package:imc_calc/components/input.dart';
import 'package:imc_calc/styles.dart';
import 'package:imc_calc/utils/auth_helper.dart';
import 'package:imc_calc/utils/db_helper.dart';

class ImcCalculatorScreen extends StatefulWidget {
  const ImcCalculatorScreen({super.key});

  @override
  State<ImcCalculatorScreen> createState() => _ImcCalculatorScreenState();
}

class _ImcCalculatorScreenState extends State<ImcCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _imcResultText = "Informe os dados!";
  Color _resultColor = AppColors.primary;
  String _userName = "";

  @override
  void initState() {
    super.initState();
    handleGetAuth(context);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getLoggedInUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user['name'] ?? '';
      });
    }
  }

  String _welcomeMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Bom dia, $_userName!";
    if (hour < 18) return "Boa tarde, $_userName!";
    return "Boa noite, $_userName!";
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _imcResultText = "Informe os dados!";
      _resultColor = AppColors.primary;
    });
  }

  void _calculateImc() {
    final String weightString = _weightController.text.replaceAll(',', '.');
    final String heightString = _heightController.text.replaceAll(',', '.');

    if (weightString.isNotEmpty && heightString.isNotEmpty) {
      try {
        final double weight = double.parse(weightString);
        final double height = double.parse(heightString);

        if (height <= 0 || height < 130 || height > 300) {
          setState(() {
            _imcResultText =
                "Altura inválida. Informe um valor entre 130 e 300 cm.";
            _resultColor = AppColors.warning;
          });
          return;
        }
        if (weight <= 0 || weight < 30 || weight > 300) {
          setState(() {
            _imcResultText =
                "Peso inválido. Informe um valor entre 30 e 300 kg.";
            _resultColor = AppColors.warning;
          });
          return;
        }

        final double imc = (weight * 10000) / (height * height);
        String classification = "";
        Color color = Colors.green;

        if (imc < 16) {
          classification = "Magreza Grave";
          color = Colors.red;
        } else if (imc <= 16.9) {
          classification = "Magreza Moderada";
          color = Colors.redAccent;
        } else if (imc <= 18.5) {
          classification = "Magreza Leve";
          color = Colors.orange;
        } else if (imc <= 24.9) {
          classification = "Peso Ideal";
          color = Colors.green;
        } else if (imc <= 29.9) {
          classification = "Sobrepeso";
          color = Colors.yellow.shade800;
        } else if (imc <= 34.9) {
          classification = "Obesidade Grau I";
          color = Colors.orange;
        } else if (imc <= 39.9) {
          classification = "Obesidade Grau II (Severa)";
          color = Colors.deepOrange;
        } else {
          classification = "Obesidade Grau III (Mórbida)";
          color = Colors.red.shade800;
        }

        setState(() {
          _imcResultText =
              "Seu IMC: ${imc.toStringAsFixed(1)}\nClassificação: $classification";
          _resultColor = color;
        });

        _weightController.clear();
        _heightController.clear();
      } catch (e) {
        setState(() {
          _imcResultText = "Valores inválidos. Use ponto para decimais.";
          _resultColor = Colors.red;
        });
      }
    } else {
      setState(() {
        _imcResultText = "Por favor, preencha o peso e a altura.";
        _resultColor = Colors.red;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha o peso e a altura.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            SizedBox(width: 8),
            Text("Calculadora IMC"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: _resetForm,
            tooltip: 'Limpar Campos',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await DatabaseHelper.instance.logoutAllUsers();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person, size: 120, color: AppColors.primary),
              SizedBox(height: 16.0),
              Text(
                _welcomeMessage(),
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.0),

              DefaultInput(
                label: 'Peso (kg)',
                hint: 'Ex: 70.5',
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),

              SizedBox(height: 20.0),

              DefaultInput(
                label: 'Altura (cm)',
                hint: 'Ex: 180',
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 30.0),

              DefaultButton(content: "Calcular", onPressed: _calculateImc),
              SizedBox(height: 10.0),
              Text(
                _imcResultText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _resultColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
