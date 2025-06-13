import 'package:flutter/material.dart';

void main() {
  runApp(const InvestimentoApp());
}

class InvestimentoApp extends StatelessWidget {
  const InvestimentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Investimentos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        useMaterial3: true,
      ),
      home: const InvestimentoPage(),
    );
  }
}

class InvestimentoPage extends StatefulWidget {
  const InvestimentoPage({super.key});

  @override
  _InvestimentoPageState createState() => _InvestimentoPageState();
}

class _InvestimentoPageState extends State<InvestimentoPage> {
  final TextEditingController _valorMensalController = TextEditingController();
  final TextEditingController _mesesController = TextEditingController();
  final TextEditingController _jurosController = TextEditingController();
  double _totalSemJuros = 0.0;
  double _totalComJuros = 0.0;

  void _simularInvestimento() {
    final valorMensal = double.tryParse(_valorMensalController.text) ?? 0.0;
    final meses = int.tryParse(_mesesController.text) ?? 0;
    final juros = double.tryParse(_jurosController.text) ?? 0.0;

    final semJuros = valorMensal * meses;

    double comJuros = 0.0;
    if (juros > 0) {
      final taxa = juros / 100;
      for (int i = 0; i < meses; i++) {
        comJuros = (comJuros + valorMensal) * (1 + taxa);
      }
    } else {
      comJuros = semJuros;
    }

    setState(() {
      _totalSemJuros = semJuros;
      _totalComJuros = comJuros;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de Investimentos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Investimento mensal:'),
            _buildTextField(
              controller: _valorMensalController,
              hint: 'Digite o valor',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 16),
            _buildLabel('Número de meses:'),
            _buildTextField(
              controller: _mesesController,
              hint: 'Quantos meses deseja investir',
              icon: Icons.calendar_month,
            ),
            const SizedBox(height: 16),
            _buildLabel('Taxa de juros ao mês:'),
            _buildTextField(
              controller: _jurosController,
              hint: 'Digite a taxa de juros (%)',
              icon: Icons.percent,
              suffix: const Text('%'),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _simularInvestimento,
                icon: const Icon(Icons.calculate),
                label: const Text('Simular'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Valor total sem juros:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'R\$ ${_totalSemJuros.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Valor total com juros compostos:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple[400],
                      ),
                    ),
                    Text(
                      'R\$ ${_totalComJuros.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
        suffix: suffix,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  void dispose() {
    _valorMensalController.dispose();
    _mesesController.dispose();
    _jurosController.dispose();
    super.dispose();
  }
}
