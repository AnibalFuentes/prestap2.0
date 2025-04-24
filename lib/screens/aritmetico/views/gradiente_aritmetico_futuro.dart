import 'package:flutter/material.dart';
import 'package:prestapp/screens/aritmetico/services/calculo_gradiente_aritmetico.dart';

class ValorFuturo extends StatefulWidget {
  const ValorFuturo({super.key});

  @override
  _ValorFuturoState createState() => _ValorFuturoState();
}

class _ValorFuturoState extends State<ValorFuturo> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _gradienteController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  String _selectedOption = "Creciente";
  String _selectedOption2 = "Valor Futuro";
  String _selectedOption3 = "Mensual";
  String _answerText = "Valor Futuro";
  double? _futureAmount;

  final GradienteACalculator _calculator = GradienteACalculator();

  void _calculateFutureValue() {
    final double capital = double.parse(_capitalController.text);
    final double rate = double.parse(_rateController.text);
    final double gradient = double.parse(_gradienteController.text);
    final double year = double.parse(_yearsController.text);
    final double month = double.parse(_monthsController.text);
    final double day = double.parse(_daysController.text);
    final double period = _calculator.calculatePeriod(
        days: day, months: month, years: year, mcuota: _selectedOption3);
    final bool perfil = (_selectedOption == "Creciente") ? true : false;

    if (_selectedOption2 == "Valor Futuro") {
      if (period != 0) {
        setState(() {
          _answerText = _selectedOption2;
          _futureAmount = _calculator.calculateFutureValue(
              pago: capital,
              gradiente: gradient,
              periodos: period,
              interes: rate,
              perfil: perfil);
        });
      } else {
        setState(() {
          _futureAmount = null;
        });
      }
    } else {
      if (period != 0) {
        setState(() {
          _answerText = _selectedOption2;
          _futureAmount = _calculator.calculateFirtsPaymentFutureValue(
              future: capital,
              gradiente: gradient,
              periodos: period,
              interes: rate,
              perfil: perfil);
        });
      } else {
        setState(() {
          _futureAmount = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          'Cálculo de Valor Futuro',
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
                    value: _selectedOption2,
                    items: ['Valor Futuro', 'Valor Primera Cuota'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption2 = newValue!;
                      });
                    },
                    prefixIcon: _selectedOption2 == 'Valor Futuro'
                        ? Icons.arrow_upward
                        : Icons.payments,
                    hintText: "Seleccione tipo de valor",
                  ),
                  const SizedBox(height: 16),

                  // Sección de parámetros
                  _buildSectionTitle("Parámetros del cálculo"),
                  const SizedBox(height: 16),

                  // Campos de entrada de datos
                  _buildInputField(
                    controller: _capitalController,
                    label: (_selectedOption2 == "Valor Futuro")
                        ? "Valor Primera Cuota"
                        : "Valor Futuro",
                    icon: Icons.payments,
                    hint: (_selectedOption2 == "Valor Futuro")
                        ? 'Ej. 1000'
                        : 'Ej. 5000',
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _rateController,
                    label: "Tasa de Interés (%)",
                    icon: Icons.percent,
                    hint: 'Ej. 0.12',
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _gradienteController,
                    label: "Gradiente",
                    icon: Icons.show_chart,
                    hint: 'Ej. 50',
                  ),
                  const SizedBox(height: 16),

                  // Sección de tiempo
                  _buildSectionTitle("Periodo de tiempo"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: _selectedOption3,
                          items: ['Mensual', 'Anual'],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOption3 = newValue!;
                            });
                          },
                          prefixIcon: Icons.calendar_today,
                          hintText: "Frecuencia",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInputField(
                          controller: _daysController,
                          label: "Días",
                          icon: Icons.calendar_view_day,
                          hint: '0',
                          isSmall: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInputField(
                          controller: _monthsController,
                          label: "Meses",
                          icon: Icons.date_range,
                          hint: '0',
                          isSmall: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInputField(
                          controller: _yearsController,
                          label: "Años",
                          icon: Icons.calendar_month,
                          hint: '0',
                          isSmall: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selector de tipo de gradiente
                  _buildDropdown(
                    value: _selectedOption,
                    items: ['Creciente', 'Decreciente'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                    prefixIcon: _selectedOption == 'Creciente'
                        ? Icons.trending_up
                        : Icons.trending_down,
                    hintText: "Tipo de gradiente",
                  ),
                  const SizedBox(height: 32),

                  // Botón de cálculo
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _calculateFutureValue,
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
                            "CALCULAR $_selectedOption2".toUpperCase(),
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
                  if (_futureAmount != null)
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
                                _futureAmount!.toStringAsFixed(2),
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
                            "$_answerText - Gradiente $_selectedOption",
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
    bool isSmall = false,
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
        contentPadding: isSmall
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
