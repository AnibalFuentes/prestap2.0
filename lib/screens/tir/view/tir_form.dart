import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/tir/services/calcular_tir.dart';

class TIRView extends StatefulWidget {
  @override
  _TIRViewState createState() => _TIRViewState();
}

class _TIRViewState extends State<TIRView> {
  final _formKey = GlobalKey<FormState>();
  final CalcularTIR _tirCalculator = CalcularTIR();

  // Controladores para los campos de entrada
  final TextEditingController _inversionController = TextEditingController();
  final TextEditingController _flujosController = TextEditingController();

  String _metodoSeleccionado = 'Calcular TIR';
  double? _resultadoTIR;

  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  void _clearFields() {
    _inversionController.clear();
    _flujosController.clear();
    setState(() {
      _resultadoTIR = null;
    });
  }

  void _calcularTIR() {
    if (_formKey.currentState!.validate()) {
      double inversionInicial = double.parse(_inversionController.text);
      List<double> flujos = _flujosController.text
          .split(',')
          .map((f) => double.parse(f.trim()))
          .toList();

      setState(() {
        if (_metodoSeleccionado == 'Calcular TIR') {
          _resultadoTIR = _tirCalculator.calcularTIR(flujos, inversionInicial);
        } else if (_metodoSeleccionado == 'Prueba y Error') {
          _resultadoTIR =
              _tirCalculator.calcularTIRPruebaError(flujos, inversionInicial);
        }
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
        title: Text(
          'Calculadora TIR',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
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
                      child: Icon(
                        Icons.trending_up,
                        size: 50,
                        color: darkYellow,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Título
                  Text(
                    'Tasa Interna de Retorno',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtítulo
                  Text(
                    'Calcule la rentabilidad de su inversión',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Campo de inversión inicial
                  _buildInputField(
                    controller: _inversionController,
                    label: 'Inversión Inicial (\$)',
                    hint: 'Ingrese el monto de la inversión inicial',
                    icon: Icons.attach_money,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la inversión inicial';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo de flujos de caja
                  _buildInputField(
                    controller: _flujosController,
                    label: 'Flujos de Caja',
                    hint:
                        'Ingrese flujos separados por comas (ej: 3000,4000,5000)',
                    icon: Icons.list_alt,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese los flujos de caja';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Selector de método
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: darkYellow.withOpacity(0.5)),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _metodoSeleccionado,
                      icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: textDark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Método de Cálculo',
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                      items: ['Calcular TIR', 'Prueba y Error']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _metodoSeleccionado = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: primaryYellow.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _calcularTIR,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: textDark,
                              backgroundColor: primaryYellow,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'CALCULAR TIR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _clearFields,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red[600],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'LIMPIAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Resultado
                  if (_resultadoTIR != null)
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _resultadoTIR! >= 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _resultadoTIR! >= 0
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tasa Interna de Retorno',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_resultadoTIR!.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _resultadoTIR! >= 0
                                  ? Colors.green
                                  : Colors.red,
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      validator: validator,
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
}
