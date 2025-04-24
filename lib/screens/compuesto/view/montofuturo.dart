import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/compuesto/services/calcularMontoFuturo.dart';

class Montofuturo extends StatefulWidget {
  const Montofuturo({super.key});

  @override
  State<Montofuturo> createState() => _MontofuturoState();
}

class _MontofuturoState extends State<Montofuturo> {
  // Definición de colores para el tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);
  final Color accentColor = const Color(0xFF6B4E00);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double? _futureAmount;
  bool _knowsExactDates = true;
  bool _showResult = false;

  String frecuenciaSeleccionada = 'Anual';
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12
  };

  final MontofuturoCalcular _calculator = MontofuturoCalcular();

  void _calculateFutureAmount() {
    if (_formKey.currentState!.validate()) {
      final double capital = double.parse(_capitalController.text);
      final double rate = double.parse(_rateController.text);
      DateTime startDate;
      DateTime endDate;
      final int veces = opcionesFrecuencia[frecuenciaSeleccionada]!;

      if (_knowsExactDates) {
        startDate = _calculator.parseDate(_startDateController.text);
        endDate = _calculator.parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate =
            startDate.add(Duration(days: days + months * 30 + years * 365));
      }

      setState(() {
        _futureAmount = _calculator.calculateFutureAmount(
          capital: capital,
          rate: rate / 100,
          startDate: startDate,
          endDate: endDate,
          vecesporano: veces,
        );
        _showResult = true;
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
          "Monto Futuro (Compuesto)",
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
                _buildSectionTitle("Datos del Cálculo"),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _capitalController,
                  labelText: "Capital Inicial",
                  prefixIcon: Icons.account_balance_wallet,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el capital inicial';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionTitle("Frecuencia de Capitalización"),
                const SizedBox(height: 16),
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
                      value: frecuenciaSeleccionada,
                      icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                      style: TextStyle(
                        color: textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          frecuenciaSeleccionada = newValue!;
                        });
                      },
                      items: opcionesFrecuencia.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(
                                _getFrequencyIcon(value),
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rateController,
                  labelText: "Tasa de Interés (%)",
                  prefixIcon: Icons.percent,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la tasa de interés';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Período de Tiempo"),
                const SizedBox(height: 16),
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
                if (_knowsExactDates) ...[
                  _buildDateField(
                    controller: _startDateController,
                    labelText: "Fecha de Inicio",
                    onTap: () => _selectDate(context, _startDateController),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _endDateController,
                    labelText: "Fecha de Finalización",
                    onTap: () => _selectDate(context, _endDateController),
                  ),
                ] else ...[
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
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateFutureAmount,
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
                          "CALCULAR MONTO FUTURO",
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
                if (_showResult && _futureAmount != null) _buildResultCard(),
              ],
            ),
          ),
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
          return 'Seleccione una fecha';
        }
        return null;
      },
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
                Icons.monetization_on,
                color: textDark,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                _calculator.formatNumber(_futureAmount!),
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
            "Monto futuro calculado",
            style: TextStyle(
              fontSize: 14,
              color: textDark.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFrequencyIcon(String frequency) {
    switch (frequency) {
      case 'Anual':
        return Icons.calendar_today;
      case 'Semestral':
        return Icons.event_repeat;
      case 'Cuatrimestral':
        return Icons.view_agenda;
      case 'Trimestral':
        return Icons.view_week;
      case 'Bimestral':
        return Icons.view_day;
      case 'Mensual':
        return Icons.calendar_view_month;
      default:
        return Icons.calculate;
    }
  }
}
