import 'package:flutter/material.dart';
import 'package:prestapp/screens/unidad_valor_real/services/calculo_unidad_valor_real.dart';
import 'package:prestapp/screens/unidad_valor_real/views/widget.dart';

class UnidadValorRealTabla extends StatefulWidget {
  const UnidadValorRealTabla({super.key});

  @override
  UnidadValorRealTablaState createState() => UnidadValorRealTablaState();
}

class UnidadValorRealTablaState extends State<UnidadValorRealTabla> {
  final TextEditingController _valorAController = TextEditingController();
  final TextEditingController _variationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  bool _showTable = false;
  List<double> _uVRAmount = [];
  List<DateTime> _fechas = [];

  final UVRCalculator _calculator = UVRCalculator();

  void _calculateUVR() {
    if (_valorAController.text.isEmpty ||
        _variationController.text.isEmpty ||
        _startDateController.text.isEmpty) {
      return;
    }

    final double valorA = double.parse(_valorAController.text);
    final double variacion = double.parse(_variationController.text);
    DateTime fInicio = _calculator.parseDate(_startDateController.text);

    final int periodoCalculo =
        DateTime(fInicio.year, fInicio.month + 1, fInicio.day)
            .difference(fInicio)
            .inDays;

    setState(() {
      _fechas =
          _calculator.createDates(fechaI: fInicio, periodo: periodoCalculo);
      _uVRAmount = _calculator.calculateListUVR(
          valorMoneda: valorA,
          variacion: variacion,
          periodoCalculo: periodoCalculo);
      _showTable = true;
    });
  }

  void _retornar() {
    setState(() {
      _uVRAmount = [];
      _showTable = false;
      _valorAController.clear();
      _variationController.clear();
      _startDateController.clear();
      _endDateController.clear();
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
        _endDateController.text = _calculator
            .formatDate(DateTime(picked.year, picked.month + 1, picked.day));
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
          'Tabla UVR',
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
                if (!_showTable) ...[
                  // Sección de formulario
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: primaryYellow.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.table_chart,
                        size: 50,
                        color: Color(0xFFC7A500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Generar Tabla UVR',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete los datos para generar la tabla',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Campos del formulario
                  buildTextField(
                    _valorAController,
                    'Valor UVR Inicial',
                    primaryColor: darkYellow,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    _variationController,
                    'Variación Mensual (%)',
                    primaryColor: darkYellow,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _startDateController,
                    label: "Fecha de Inicio",
                    onTap: () => _selectDate(context, _startDateController),
                    primaryColor: darkYellow,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _endDateController,
                    label: "Fecha de Finalización",
                    readOnly: true,
                    primaryColor: darkYellow,
                  ),
                  const SizedBox(height: 32),

                  // Botón de cálculo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _calculateUVR,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryYellow,
                        foregroundColor: textDark,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'GENERAR TABLA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Sección de resultados
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _retornar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkYellow,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'NUEVO CÁLCULO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabla (se mantiene exactamente igual)
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    width: 350,
                    height: 400,
                    child: ListView(
                      children: [
                        UVRTable(
                          listaN: _uVRAmount
                              .map((uVRAmount) =>
                                  _uVRAmount.lastIndexOf(uVRAmount) + 1)
                              .toList(),
                          listaF: _fechas
                              .map((fecha) => _calculator.formatDate(fecha))
                              .toList(),
                          listaUVR: _uVRAmount,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    VoidCallback? onTap,
    bool readOnly = false,
    required Color primaryColor,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: !readOnly
            ? IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: onTap,
                color: primaryColor,
              )
            : null,
      ),
      onTap: onTap,
    );
  }
}

// Widget buildTextField modificado para aceptar color primario
Widget buildTextField(TextEditingController controller, String label,
    {required Color primaryColor}) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
