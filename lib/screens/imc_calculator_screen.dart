import 'package:flutter/material.dart';

class ImcCalculatorScreen extends StatefulWidget {
  const ImcCalculatorScreen({super.key});

  @override
  State<ImcCalculatorScreen> createState() => _ImcCalculatorScreenState();
}

class _ImcCalculatorScreenState extends State<ImcCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _imcResultText = "Informe a dados!";

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _weightController.text = "";
    _heightController.text = "";

    setState(() {
      _imcResultText = "Informe a dados!";
    });
  }

  void _calculateImc() {
    final String weightString = _weightController.text.replaceAll(',', '.');
    final String heightString = _heightController.text.replaceAll(',', '.');

    if (weightString.isNotEmpty && heightString.isNotEmpty) {
      try {
        final double weight = double.parse(weightString);
        final double height = double.parse(heightString);

        if (height <= 0) {
          setState(() {
            _imcResultText =
                "Altura inválida (cm). Informe um valor maior que zero.";
          });
          return;
        }
        if (weight <= 0) {
          setState(() {
            _imcResultText = "Peso inválido. Informe um valor maior que zero.";
          });
          return;
        }

        if (height < 130 || height > 300) {
          setState(() {
            _imcResultText = "Altura inválida. Informe um valor válido.";
          });
          return;
        }
        if (weight < 30 || weight > 300) {
          setState(() {
            _imcResultText = "Peso inválido. Informe um valor válido.";
          });
          return;
        }

        final double imc = (weight * 10000) / (height * height);
        String classification = "";

        if (imc < 16) {
          classification = "Magreza Grave";
        } else if (imc >= 16 && imc <= 16.9) {
          classification = "Magreza Moderada";
        } else if (imc >= 17 && imc <= 18.5) {
          classification = "Magreza Leve";
        } else if (imc >= 18.6 && imc <= 24.9) {
          classification = "Peso Ideal";
        } else if (imc >= 25 && imc <= 29.9) {
          classification = "Sobrepeso";
        } else if (imc >= 30 && imc <= 34.9) {
          classification = "Obesidade Grau I";
        } else if (imc >= 35 && imc <= 39.9) {
          classification = "Obesidade Grau II (Severa)";
        } else if (imc >= 40) {
          classification = "Obesidade Grau III (Mórbida)";
        }

        setState(() {
          _imcResultText =
              "Seu IMC: ${imc.toStringAsFixed(1)}\nClassificação: $classification";
        });
      } catch (e) {
        setState(() {
          _imcResultText = "Valores inválidos. Use '.' para decimais.";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, insira números válidos para peso e altura. Use ponto para decimais.',
            ),
          ),
        );
      }
    } else {
      setState(() {
        _imcResultText = "Por favor, preencha o peso e a altura.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha o peso e a altura.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () => _resetForm(),
            tooltip: 'Limpar Campos',
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
              Icon(Icons.person, size: 120, color: Colors.green),
              SizedBox(height: 30.0),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  hintText: 'Ex: 70.5',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  hintText: 'Ex: 180',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _calculateImc,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Calcular'),
              ),
              SizedBox(height: 10.0),
              Text(
                _imcResultText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
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
