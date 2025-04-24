import 'package:flutter/material.dart';
import 'package:prestapp/screens/aritmetico/views/widget.dart';
import 'package:prestapp/screens/unidad_valor_real/services/calculo_unidad_valor_real.dart';

class UnidadValorReal extends StatefulWidget {
  const UnidadValorReal({super.key});

  @override
  UnidadValorRealState createState() => UnidadValorRealState();
}

class UnidadValorRealState extends State<UnidadValorReal> {
  final TextEditingController _valorAController = TextEditingController();
  final TextEditingController _variationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  double? _uVRAmount;
  final UVRCalculator _calculator = UVRCalculator();

  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  void _calculateUVR() {
    if (_valorAController.text.isEmpty ||
        _variationController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      return;
    }

    final double valorA = double.parse(_valorAController.text);
    final double variacion = double.parse(_variationController.text);
    DateTime fInicio = _calculator.parseDate(_startDateController.text);
    DateTime fFinal = _calculator.parseDate(_endDateController.text);
    final int numeroDias = fFinal.difference(fInicio).inDays;
    final int periodoCalculo =
        DateTime(fInicio.year, fInicio.month + 1, fInicio.day)
            .difference(fInicio)
            .inDays;

    setState(() {
      _uVRAmount = _calculator.calculateUVR(
          valorMoneda: valorA,
          variacion: variacion,
          numDias: numeroDias,
          periodoCalculo: periodoCalculo);
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = _calculator.formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: const Text(
          'Unidad de Valor Real',
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDE7), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Icono principal
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: primaryYellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.currency_exchange,
                      size: 50,
                      color: Color(0xFFC7A500),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Título
                const Text(
                  'Calculadora UVR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),

                const SizedBox(height: 8),

                // Subtítulo
                const Text(
                  'Calcule el valor actualizado según inflación',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 32),

                // Campos de entrada
                _buildInputField(
                  controller: _valorAController,
                  label: 'Valor UVR Anterior',
                  hint: 'Ingrese el valor anterior de la UVR',
                  icon: Icons.attach_money,
                ),

                const SizedBox(height: 16),

                _buildInputField(
                  controller: _variationController,
                  label: 'Variación del IPC (%)',
                  hint: 'Ingrese el porcentaje de variación',
                  icon: Icons.percent,
                ),

                const SizedBox(height: 16),

                // Fecha de inicio
                _buildDateField(
                  controller: _startDateController,
                  label: 'Fecha de Inicio',
                  onTap: () => _selectDate(context, _startDateController),
                ),

                const SizedBox(height: 16),

                // Fecha de cálculo
                _buildDateField(
                  controller: _endDateController,
                  label: 'Fecha de Cálculo',
                  onTap: () => _selectDate(context, _endDateController),
                ),

                const SizedBox(height: 32),

                // Botón calcular
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryYellow.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _calculateUVR,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textDark,
                      backgroundColor: primaryYellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'CALCULAR UVR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Resultado
                if (_uVRAmount != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: darkYellow.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Unidad de Valor Real:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_uVRAmount!.toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: darkYellow),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.calendar_today, color: darkYellow),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onTap,
          color: darkYellow,
        ),
      ),
      onTap: onTap,
    );
  }
}
