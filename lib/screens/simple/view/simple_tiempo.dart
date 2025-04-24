import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/simple/services/interes_calculator.dart';

class SimpleTiempo extends StatefulWidget {
  const SimpleTiempo({super.key});

  @override
  _SimpleTiempoState createState() => _SimpleTiempoState();
}

class _SimpleTiempoState extends State<SimpleTiempo> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);
  final Color accentColor = const Color(0xFF6B4E00);

  final _formKey = GlobalKey<FormState>();
  final _interesPagadoController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _finalCapitalController = TextEditingController();

  double? _time;
  String _selectedView = 'Todos';
  bool _showResult = false;

  final InterestCalculator _calculator = InterestCalculator();

  void _calculateTime() {
    if (_formKey.currentState!.validate()) {
      final interesPagado = double.tryParse(_interesPagadoController.text);
      final initialCapital = double.tryParse(_initialCapitalController.text);
      final finalCapital = double.tryParse(_finalCapitalController.text);
      final interestRate = double.tryParse(_interestRateController.text);

      if (initialCapital == null || initialCapital <= 0) {
        _showErrorSnackbar('Capital inicial debe ser mayor a cero');
        return;
      }

      if (interestRate == null || interestRate <= 0) {
        _showErrorSnackbar('Tasa de interés debe ser mayor a cero');
        return;
      }

      double? calculatedInterest;

      if (interesPagado == null && finalCapital != null) {
        calculatedInterest = finalCapital - initialCapital;
      } else {
        calculatedInterest = interesPagado;
      }

      if (calculatedInterest != null) {
        final time = _calculator.calculateTime(
            calculatedInterest, initialCapital, interestRate);
        setState(() {
          _time = time;
          _showResult = true;
        });
      } else {
        _showErrorSnackbar('Ingrese interés pagado o capital final');
      }
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

  Map<String, int> _convertTime(double timeInYears) {
    int years = timeInYears.floor();
    double remainingMonths = (timeInYears - years) * 12;
    int months = remainingMonths.floor();
    double remainingDays = (remainingMonths - months) * 30;
    int days = remainingDays.floor();

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          "Cálculo del Tiempo",
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
                  controller: _initialCapitalController,
                  labelText: "Capital Inicial",
                  prefixIcon: Icons.account_balance_wallet,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el capital inicial';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _interesPagadoController,
                  labelText: "Interés Pagado (Opcional)",
                  prefixIcon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _finalCapitalController,
                  labelText: "Capital Final (Opcional)",
                  prefixIcon: Icons.trending_up,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _interestRateController,
                  labelText: "Tasa de Interés (%)",
                  prefixIcon: Icons.percent,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la tasa de interés';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Formato de Resultado"),
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
                      value: _selectedView,
                      icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                      style: TextStyle(
                        color: textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedView = newValue!;
                        });
                      },
                      items: <String>['Todos', 'Años', 'Meses', 'Días']
                          .map<DropdownMenuItem<String>>((String value) {
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
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateTime,
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
                        Icon(Icons.access_time, color: textDark),
                        const SizedBox(width: 8),
                        Text(
                          "CALCULAR TIEMPO",
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
                if (_showResult && _time != null) _buildResultCard(),
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
    final timeComponents = _convertTime(_time!);
    String timeText;

    switch (_selectedView) {
      case 'Años':
        timeText = '${timeComponents['years']} años';
        break;
      case 'Meses':
        timeText = '${timeComponents['months']} meses';
        break;
      case 'Días':
        timeText = '${timeComponents['days']} días';
        break;
      default:
        timeText =
            '${timeComponents['years']} años, ${timeComponents['months']} meses, ${timeComponents['days']} días';
    }

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
                Icons.access_time,
                color: textDark,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Tiempo: ${_time!.toStringAsFixed(2)} años',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 16,
              color: textDark.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForOption(String option) {
    switch (option) {
      case 'Años':
        return Icons.calendar_today;
      case 'Meses':
        return Icons.date_range;
      case 'Días':
        return Icons.calendar_view_day;
      default:
        return Icons.view_agenda;
    }
  }
}
