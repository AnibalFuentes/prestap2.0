import 'package:flutter/material.dart';
import '../services/geometric_gradient_calculator.dart';

class GeometricValueCalculator extends StatefulWidget {
  const GeometricValueCalculator({super.key});

  @override
  _GeometricValueCalculatorState createState() =>
      _GeometricValueCalculatorState();
}

class _GeometricValueCalculatorState extends State<GeometricValueCalculator> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final _seriePagosController = TextEditingController();
  final _variacionController = TextEditingController();
  final _interesController = TextEditingController();
  final _periodosController = TextEditingController();

  String _valueType = 'Valor Presente'; // Default value
  String _growthType = 'Creciente'; // Default value
  double? _calculatedValue;

  void _calculateValue() {
    final double? A = double.tryParse(_seriePagosController.text);
    final double? G = double.tryParse(_variacionController.text);
    final double? i = double.tryParse(_interesController.text);
    final int? n = int.tryParse(_periodosController.text);

    // Verifica si alguna entrada no es válida
    if (A == null || G == null || i == null || n == null) {
      setState(() {
        _calculatedValue = null; // No mostrar resultado si hay un error
      });
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, ingresa valores válidos.'),
          backgroundColor: textDark,
        ),
      );
      return;
    }

    final calculator = GeometricGradientCalculator();
    double result;

    if (_valueType == 'Valor Presente') {
      if (_growthType == 'Creciente') {
        result =
            calculator.calculateValorPresenteCreciente(A: A, G: G, i: i, n: n);
      } else {
        result = calculator.calculateValorPresenteDecreciente(
            A: A, G: G, i: i, n: n);
      }
    } else {
      if (_growthType == 'Creciente') {
        result =
            calculator.calculateValorFuturoCreciente(A: A, G: G, i: i, n: n);
      } else {
        result =
            calculator.calculateValorFuturoDecreciente(A: A, G: G, i: i, n: n);
      }
    }

    setState(() {
      _calculatedValue = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          'Cálculo de Valor Geométrico',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        backgroundColor: primaryYellow,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightYellow, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con icono
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: primaryYellow.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.trending_up,
                        size: 40,
                        color: darkYellow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sección de selección de tipo de cálculo
                  _buildSectionTitle("Tipo de cálculo"),
                  const SizedBox(height: 16),

                  // Selector de tipo de valor
                  _buildDropdown(
                    value: _valueType,
                    items: ['Valor Presente', 'Valor Futuro'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _valueType = newValue!;
                      });
                    },
                    prefixIcon: _valueType == 'Valor Presente'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    hintText: "Seleccione tipo de valor",
                  ),
                  const SizedBox(height: 16),

                  // Selector de tipo de crecimiento
                  _buildDropdown(
                    value: _growthType,
                    items: ['Creciente', 'Decreciente'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _growthType = newValue!;
                      });
                    },
                    prefixIcon: _growthType == 'Creciente'
                        ? Icons.trending_up
                        : Icons.trending_down,
                    hintText: "Seleccione tipo de gradiente",
                  ),
                  const SizedBox(height: 24),

                  // Sección de parámetros
                  _buildSectionTitle("Parámetros del cálculo"),
                  const SizedBox(height: 16),

                  // Campos de entrada de datos
                  _buildInputField(
                    controller: _seriePagosController,
                    label: 'Serie de Pagos (A)',
                    icon: Icons.payments,
                    hint: 'Ej. 1000',
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _variacionController,
                    label: 'Variación (G)',
                    icon: Icons.show_chart,
                    hint: 'Ej. 0.05',
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _interesController,
                    label: 'Tasa de Interés (i)',
                    icon: Icons.percent,
                    hint: 'Ej. 0.12',
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _periodosController,
                    label: 'Número de Periodos (n)',
                    icon: Icons.schedule,
                    hint: 'Ej. 12',
                  ),
                  const SizedBox(height: 32),

                  // Botón de cálculo
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _calculateValue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryYellow,
                        foregroundColor: textDark,
                        elevation: 4,
                        shadowColor: primaryYellow.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate, color: textDark),
                          const SizedBox(width: 8),
                          Text(
                            "CALCULAR",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resultado del cálculo
                  if (_calculatedValue != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [darkYellow, primaryYellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: darkYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Resultado del cálculo",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textDark.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: textDark,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _calculatedValue!.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$_valueType $_growthType",
                            style: TextStyle(
                              fontSize: 14,
                              color: textDark.withOpacity(0.8),
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

  // Widget para crear títulos de sección con estilo consistente
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: darkYellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para crear campos de texto con estilo consistente
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textDark.withOpacity(0.7)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: darkYellow),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryYellow, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Widget para crear desplegables con estilo consistente
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData prefixIcon,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryYellow),
        boxShadow: [
          BoxShadow(
            color: primaryYellow.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(prefixIcon, color: darkYellow),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                hint: Text(
                  hintText,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
