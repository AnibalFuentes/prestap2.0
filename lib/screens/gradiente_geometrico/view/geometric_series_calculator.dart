import 'package:flutter/material.dart';

class GeometricSeriesCalculator extends StatefulWidget {
  const GeometricSeriesCalculator({super.key});

  @override
  _GeometricSeriesCalculatorState createState() =>
      _GeometricSeriesCalculatorState();
}

class _GeometricSeriesCalculatorState extends State<GeometricSeriesCalculator> {
  // Definición de colores para el tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);
  final Color accentColor = const Color(0xFF6B4E00);

  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _variacionController = TextEditingController();
  final _interesController = TextEditingController();
  final _periodosController = TextEditingController();

  String _valueType = 'Valor Presente';
  String _growthType = 'Creciente';
  double? _calculatedValue;
  bool _showResult = false;

  void _calculateSeriesValue() {
    if (_formKey.currentState!.validate()) {
      final double? VP_or_VF = double.tryParse(_valorController.text);
      final double? G = double.tryParse(_variacionController.text);
      final double? i = double.tryParse(_interesController.text);
      final int? n = int.tryParse(_periodosController.text);

      if (VP_or_VF == null || G == null || i == null || n == null) {
        _showErrorSnackbar('Ingrese valores válidos en todos los campos');
        return;
      }

      if (i <= 0) {
        _showErrorSnackbar('La tasa de interés debe ser mayor a cero');
        return;
      }

      if (n <= 0) {
        _showErrorSnackbar('El número de periodos debe ser mayor a cero');
        return;
      }

      double result = 0.0;
      // Aquí irían las fórmulas reales de cálculo
      // Esto es solo un ejemplo de estructura
      if (_valueType == 'Valor Presente') {
        if (_growthType == 'Creciente') {
          result = VP_or_VF * (1 + i / 100) * n / (1 + G / 100);
        } else {
          result = VP_or_VF * (1 + i / 100) * n / (1 - G / 100);
        }
      } else {
        if (_growthType == 'Creciente') {
          result = VP_or_VF / ((1 + i / 100) * n) * (1 + G / 100);
        } else {
          result = VP_or_VF / ((1 + i / 100) * n) * (1 - G / 100);
        }
      }

      setState(() {
        _calculatedValue = result;
        _showResult = true;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          "Serie Geométrica",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Tipo de Cálculo"),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _valueType,
                  items: ['Valor Presente', 'Valor Futuro'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _valueType = newValue!;
                    });
                  },
                  icon: Icons.calculate,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Tipo de Serie"),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _growthType,
                  items: ['Creciente', 'Decreciente'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _growthType = newValue!;
                    });
                  },
                  icon: _growthType == 'Creciente'
                      ? Icons.trending_up
                      : Icons.trending_down,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Datos de Entrada"),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _valorController,
                  labelText: _valueType,
                  prefixIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el valor';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _variacionController,
                  labelText: 'Variación (G) %',
                  prefixIcon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la variación';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _interesController,
                  labelText: 'Tasa de Interés (i) %',
                  prefixIcon: Icons.percent,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la tasa de interés';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Ingrese un valor positivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _periodosController,
                  labelText: 'Número de Periodos (n)',
                  prefixIcon: Icons.timelapse,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el número de periodos';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Ingrese un entero positivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateSeriesValue,
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
                        const Text(
                          "CALCULAR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_showResult && _calculatedValue != null) _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: darkYellow),
          style: TextStyle(
            color: textDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, color: darkYellow, size: 20),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textDark.withOpacity(0.7)),
        prefixIcon: Icon(prefixIcon, color: darkYellow),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

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

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
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
                Icons.attach_money,
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
            "Valor de la serie geométrica",
            style: TextStyle(
              fontSize: 14,
              color: textDark.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
