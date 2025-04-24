import 'package:flutter/material.dart';
import 'dart:math';

class SimpleInteres extends StatefulWidget {
  const SimpleInteres({super.key});

  @override
  _SimpleInteresState createState() => _SimpleInteresState();
}

class _SimpleInteresState extends State<SimpleInteres> {
  // Definición de colores para el tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);
  final Color accentColor = const Color(0xFF6B4E00);

  // Controladores para los campos principales
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interesGeneradoController = TextEditingController();

  // Controladores para fechas exactas
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Controladores para tiempo manual
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  double? _interestRate;
  bool _useExactDates = false;
  bool _showResult = false;

  void _calculateInterestRate() {
    if (_initialCapitalController.text.isEmpty) {
      _showErrorSnackbar('Por favor ingrese el capital inicial');
      return;
    }

    final initialCapital = double.tryParse(_initialCapitalController.text);
    if (initialCapital == null || initialCapital <= 0) {
      _showErrorSnackbar('Capital inicial debe ser mayor a cero');
      return;
    }

    double? timeInYears;

    if (_useExactDates) {
      final startDate = DateTime.tryParse(_startDateController.text);
      final endDate = DateTime.tryParse(_endDateController.text);

      if (startDate == null || endDate == null) {
        _showErrorSnackbar('Seleccione ambas fechas');
        return;
      }

      if (endDate.isBefore(startDate)) {
        _showErrorSnackbar('La fecha final debe ser posterior a la inicial');
        return;
      }

      final difference = endDate.difference(startDate).inDays;
      timeInYears = difference / 365.0;
    } else {
      final days = int.tryParse(_dayController.text) ?? 0;
      final months = int.tryParse(_monthController.text) ?? 0;
      final years = int.tryParse(_yearController.text) ?? 0;

      if (days == 0 && months == 0 && years == 0) {
        _showErrorSnackbar('Ingrese al menos un valor de tiempo');
        return;
      }

      timeInYears = years + (months / 12) + (days / 360);
    }

    final interesGenerado = double.tryParse(_interesGeneradoController.text);
    final futureAmount = double.tryParse(_futureAmountController.text);

    if (interesGenerado != null && interesGenerado > 0) {
      final rate = (interesGenerado / (initialCapital * timeInYears)) * 100;
      setState(() {
        _interestRate = rate.toDouble();
        _showResult = true;
      });
    } else if (futureAmount != null && futureAmount > 0) {
      final rate =
          (pow(futureAmount / initialCapital, 1 / timeInYears) - 1) * 100;
      setState(() {
        _interestRate = rate as double?;
        _showResult = true;
      });
    } else {
      _showErrorSnackbar('Ingrese monto futuro o interés generado');
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
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          "Cálculo de Tasa de Interés",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Datos del Cálculo"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _initialCapitalController,
                labelText: "Capital Inicial",
                prefixIcon: Icons.account_balance_wallet,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _futureAmountController,
                labelText: "Monto Futuro (Opcional)",
                prefixIcon: Icons.trending_up,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _interesGeneradoController,
                labelText: "Interés Generado (Opcional)",
                prefixIcon: Icons.percent,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Período de Tiempo"),
              const SizedBox(height: 16),
              _buildDateOptions(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _calculateInterestRate,
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
                        "CALCULAR TASA",
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
              if (_showResult && _interestRate != null) _buildResultCard(),
            ],
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDateOptions() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryYellow, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                "¿Conoces las fechas exactas?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
              value: _useExactDates,
              activeColor: darkYellow,
              activeTrackColor: primaryYellow.withOpacity(0.5),
              onChanged: (bool value) {
                setState(() {
                  _useExactDates = value;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_useExactDates)
              Column(
                children: [
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
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _dayController,
                          labelText: "Días",
                          prefixIcon: Icons.calendar_view_day,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: _monthController,
                          labelText: "Meses",
                          prefixIcon: Icons.date_range,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: _yearController,
                          labelText: "Años",
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
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
                Icons.percent,
                color: textDark,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                "${_interestRate!.toStringAsFixed(2)}%",
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
            "Tasa de interés calculada",
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
