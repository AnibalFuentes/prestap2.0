import 'package:flutter/material.dart';
import 'package:prestapp/screens/simple/services/interes_calculator.dart';

class SimpleForms extends StatefulWidget {
  const SimpleForms({super.key});

  @override
  State<SimpleForms> createState() => _SimpleFormsState();
}

class _SimpleFormsState extends State<SimpleForms> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);
  final Color accentColor = const Color(0xFF6B4E00);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _finalCapitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double? _result;
  bool _knowsExactDates = true;
  String _selectedOption = 'Monto futuro';
  final InterestCalculator _calculator = InterestCalculator();

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double? capital = _capitalController.text.isNotEmpty
          ? double.tryParse(_capitalController.text)
          : null;
      final double? finalCapital = _finalCapitalController.text.isNotEmpty
          ? double.tryParse(_finalCapitalController.text)
          : null;
      final double rate = double.parse(_rateController.text);
      DateTime startDate;
      DateTime endDate;

      if (_knowsExactDates) {
        startDate = _calculator.parseDate(_startDateController.text);
        endDate = _calculator.parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate =
            startDate.add(Duration(days: days + months * 30 + years * 360));
      }

      setState(() {
        if (capital != null && finalCapital == null) {
          if (_selectedOption == 'Monto futuro') {
            _result = _calculator.calculateFutureAmount(
              capital: capital,
              rate: rate,
              startDate: startDate,
              endDate: endDate,
            );
          } else if (_selectedOption == 'Interés') {
            final double years =
                int.tryParse(_yearsController.text)?.toDouble() ?? 0;
            final double months =
                (int.tryParse(_monthsController.text)?.toDouble() ?? 0) / 12;
            final double days =
                (int.tryParse(_daysController.text)?.toDouble() ?? 0) / 360;
            final double totalTime = years + months + days;
            _result = (capital * (rate / 100)) * totalTime;
          } else if (_selectedOption == 'Capital') {
            final double time = endDate.difference(startDate).inDays / 360;
            final tiempo = int.tryParse(_yearsController.text) ??
                int.tryParse(_monthsController.text) ??
                int.tryParse(_daysController.text) ??
                time;
            _result = (capital / ((rate / 100) * tiempo));
          }
        } else if (capital == null && finalCapital != null) {
          if (_selectedOption == 'Principal prestamo') {
            _result = _calculator.calculateInitialCapitalPrestamo(
              finalCapital: finalCapital,
              rate: rate,
              tiempo: int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
          } else {
            final initialCapital = _calculator.calculateInitialCapital(
              finalCapital: finalCapital,
              rate: rate,
              tiempo: int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
            _result = initialCapital;
          }
        }
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryYellow,
              onPrimary: textDark,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
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
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          "Cálculo del Monto",
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de sección
                  _buildSectionTitle("Información del capital"),
                  const SizedBox(height: 16),

                  // Campo de Capital Inicial
                  _buildTextField(
                    controller: _capitalController,
                    labelText: "Capital Inicial",
                    prefixIcon: Icons.account_balance_wallet,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Capital Final
                  _buildTextField(
                    controller: _finalCapitalController,
                    labelText: "Capital Final",
                    prefixIcon: Icons.trending_up,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Tasa de Interés
                  _buildTextField(
                    controller: _rateController,
                    labelText: "Tasa de Interés (%)",
                    prefixIcon: Icons.percent,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la tasa de interés';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Título de sección
                  _buildSectionTitle("Período de tiempo"),
                  const SizedBox(height: 16),

                  // Switch para selección de tipo de entrada de tiempo
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: primaryYellow, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: SwitchListTile(
                        title: Text(
                          "¿Conoce las fechas exactas?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textDark,
                          ),
                        ),
                        subtitle: Text(
                          _knowsExactDates
                              ? "Usar fechas de inicio y fin"
                              : "Usar días, meses y años",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        value: _knowsExactDates,
                        activeColor: darkYellow,
                        activeTrackColor: primaryYellow.withOpacity(0.5),
                        onChanged: (bool value) {
                          setState(() {
                            _knowsExactDates = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campos condicionales según la selección del switch
                  if (_knowsExactDates) ...[
                    // Fecha de inicio
                    _buildDateField(
                      controller: _startDateController,
                      labelText: "Fecha de Inicio",
                      onTap: () => _selectDate(context, _startDateController),
                    ),
                    const SizedBox(height: 16),

                    // Fecha de fin
                    _buildDateField(
                      controller: _endDateController,
                      labelText: "Fecha de Finalización",
                      onTap: () => _selectDate(context, _endDateController),
                    ),
                  ] else ...[
                    // Campos para ingresar días, meses y años
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _daysController,
                            labelText: "Días",
                            prefixIcon: Icons.calendar_view_day,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: _monthsController,
                            labelText: "Meses",
                            prefixIcon: Icons.date_range,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: _yearsController,
                            labelText: "Años",
                            prefixIcon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Título de sección
                  _buildSectionTitle("Tipo de cálculo"),
                  const SizedBox(height: 16),

                  // Dropdown para seleccionar tipo de cálculo
                  Container(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedOption,
                        icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                        style: TextStyle(
                          color: textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                          });
                        },
                        items: <String>[
                          'Monto futuro',
                          'Monto inicial',
                          'Interés',
                          'Principal prestamo',
                          'Capital'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  _getIconForOption(value),
                                  color: darkYellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón de cálculo
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _calculate,
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
                  if (_result != null)
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
                                _calculator.formatNumber(_result!),
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
                            "Valor calculado: $_selectedOption",
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

  // Widget para crear campos de texto con estilo consistente
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

  // Widget para crear campos de fecha con estilo consistente
  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textDark.withOpacity(0.7)),
        prefixIcon: Icon(Icons.calendar_month, color: darkYellow),
        suffixIcon: Icon(Icons.arrow_drop_down, color: darkYellow),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione una fecha';
        }
        return null;
      },
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

  // Método para obtener un icono según el tipo de cálculo
  IconData _getIconForOption(String option) {
    switch (option) {
      case 'Monto futuro':
        return Icons.trending_up;
      case 'Monto inicial':
        return Icons.account_balance_wallet;
      case 'Interés':
        return Icons.percent;
      case 'Principal prestamo':
        return Icons.money;
      case 'Capital':
        return Icons.attach_money;
      default:
        return Icons.calculate;
    }
  }
}
