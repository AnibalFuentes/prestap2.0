import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class LoanWidget extends StatefulWidget {
  final Function(double) onLoanMade;

  const LoanWidget({super.key, required this.onLoanMade});

  @override
  _LoanWidgetState createState() => _LoanWidgetState();
}

class _LoanWidgetState extends State<LoanWidget> {
  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _termController = TextEditingController();

  String _loanType = "simple";
  String _amortizationType = "francesa";
  List<double> _monthlyPayments = [];
  DateTime? _endDate;

  void _calculateLoan() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double rate = (double.tryParse(_rateController.text) ?? 0) / 100;
    int term = int.tryParse(_termController.text) ?? 0;

    if (amount > 0 && rate > 0 && term > 0) {
      _monthlyPayments.clear();

      if (_loanType == "simple") {
        if (_amortizationType == "francesa") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  "Amortización Francesa no es compatible con interés Simple"),
              backgroundColor: darkYellow,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
        double totalAmount = amount * (1 + rate * term);
        _monthlyPayments.add(totalAmount / (term * 12));
      } else {
        double totalAmount = amount * pow((1 + rate / 12), 12 * term);
        switch (_amortizationType) {
          case "francesa":
            double monthlyRate = rate / 12;
            int totalPayments = term * 12;
            double monthlyPayment = amount *
                monthlyRate /
                (1 - pow(1 + monthlyRate, -totalPayments));
            for (int i = 0; i < totalPayments; i++) {
              _monthlyPayments.add(monthlyPayment);
            }
            break;
          case "alemana":
            double germanBasePayment = amount / (term * 12);
            for (int i = 0; i < term * 12; i++) {
              double interestPayment =
                  (amount - (i * germanBasePayment)) * rate / 12;
              _monthlyPayments.add(germanBasePayment + interestPayment);
            }
            break;
          case "americana":
            for (int i = 0; i < term * 12; i++) {
              _monthlyPayments.add(amount * (rate / 12));
            }
            break;
        }
      }

      _endDate = DateTime.now().add(Duration(days: term * 365));
      widget.onLoanMade(amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor, ingrese valores válidos"),
          backgroundColor: darkYellow,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    setState(() {});
  }
// Agrega estos métodos a la clase _LoanWidgetState

  double _calculateTotalPayment() {
    if (_loanType == "simple") {
      return double.parse(_amountController.text) *
          (1 +
              (double.parse(_rateController.text) /
                  100 *
                  int.parse(_termController.text)));
    } else {
      return _monthlyPayments.fold(0, (sum, payment) => sum + payment);
    }
  }

  double _calculateTotalInterest() {
    return _calculateTotalPayment() - double.parse(_amountController.text);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: darkYellow),
          ),
          Text(
            "\$$value",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(int index, double payment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Cuota $index",
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            "\$${payment.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showFullPaymentSchedule(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calendar_today, color: darkYellow),
            const SizedBox(width: 8),
            Text(
              "Tabla de Amortización Completa",
              style: TextStyle(color: darkYellow),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < _monthlyPayments.length; i++)
                  _buildPaymentRow(i + 1, _monthlyPayments[i]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cerrar",
              style: TextStyle(color: darkYellow),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: Text(
          'Simulador de Préstamos',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.credit_score,
                      size: 50,
                      color: Color(0xFFC7A500),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Campos del formulario
                _buildInputField(
                  controller: _amountController,
                  label: "Monto del préstamo",
                  hint: "Ingrese el monto del préstamo",
                  icon: Icons.attach_money,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _rateController,
                  label: "Tasa de interés (% anual)",
                  hint: "Ingrese la tasa de interés",
                  icon: Icons.percent,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _termController,
                  label: "Plazo (años)",
                  hint: "Ingrese el plazo en años",
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 24),

                // Tipo de interés
                const Text(
                  "Tipo de interés:",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioOption(
                        value: "simple",
                        groupValue: _loanType,
                        label: "Interés Simple",
                        onChanged: (value) {
                          setState(() {
                            _loanType = value ?? "simple";
                            if (_loanType == "simple" &&
                                _amortizationType == "francesa") {
                              _amortizationType = "alemana";
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildRadioOption(
                        value: "compuesto",
                        groupValue: _loanType,
                        label: "Interés Compuesto",
                        onChanged: (value) {
                          setState(() {
                            _loanType = value ?? "simple";
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tipo de amortización
                const Text(
                  "Tipo de amortización:",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121)),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkYellow.withOpacity(0.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _amortizationType,
                    icon: Icon(Icons.arrow_drop_down, color: darkYellow),
                    items: <String>['francesa', 'alemana', 'americana']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.capitalizeFirstOfEach),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _amortizationType = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Botón calcular
                Center(
                  child: Container(
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
                      onPressed: _calculateLoan,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: textDark,
                        backgroundColor: primaryYellow,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "CALCULAR PRÉSTAMO",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Reemplaza la sección de resultados en el build method con este código:
                if (_monthlyPayments.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: darkYellow.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.summarize, color: darkYellow, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "RESUMEN DEL PRÉSTAMO",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkYellow),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Información resumida
                        _buildDetailRow(
                            "Monto inicial:", _amountController.text),
                        _buildDetailRow("Tasa de interés:",
                            "${_rateController.text}% anual"),
                        _buildDetailRow(
                            "Plazo:", "${_termController.text} años"),
                        _buildDetailRow(
                            "Tipo de interés:",
                            _loanType == "simple"
                                ? "Interés Simple"
                                : "Interés Compuesto"),
                        _buildDetailRow("Sistema de amortización:",
                            _amortizationType.capitalizeFirstOfEach),

                        const Divider(
                            height: 24, thickness: 1, color: Colors.grey),

                        // Totales importantes
                        _buildTotalRow("Total a pagar:",
                            _calculateTotalPayment().toStringAsFixed(2)),
                        _buildTotalRow("Total intereses:",
                            _calculateTotalInterest().toStringAsFixed(2)),
                        _buildTotalRow("Fecha final:",
                            DateFormat('dd/MM/yyyy').format(_endDate!)),

                        const SizedBox(height: 16),
                        const Divider(
                            height: 24, thickness: 1, color: Colors.grey),

                        // Cuotas mensuales (mostrar solo las primeras 3 y las últimas 3)
                        Text(
                          "DETALLE DE CUOTAS",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkYellow),
                        ),
                        const SizedBox(height: 8),

                        if (_monthlyPayments.length <= 6) ...[
                          ..._monthlyPayments.asMap().entries.map((entry) =>
                              _buildPaymentRow(entry.key + 1, entry.value)),
                        ] else ...[
                          // Mostrar primeras 3 cuotas
                          ..._monthlyPayments.sublist(0, 3).asMap().entries.map(
                              (entry) =>
                                  _buildPaymentRow(entry.key + 1, entry.value)),

                          // Separador visual
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Center(
                              child: Text(
                                "··· ${_monthlyPayments.length - 6} cuotas intermedias ···",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),

                          // Mostrar últimas 3 cuotas
                          ..._monthlyPayments
                              .sublist(_monthlyPayments.length - 3)
                              .asMap()
                              .entries
                              .map((entry) => _buildPaymentRow(
                                  _monthlyPayments.length - 2 + entry.key,
                                  entry.value)),
                        ],

                        const SizedBox(height: 8),
                        Text(
                          "* Cuota fija mensual: ${_monthlyPayments[0].toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón para ver tabla completa
                  if (_monthlyPayments.length > 6) ...[
                    TextButton(
                      onPressed: () => _showFullPaymentSchedule(context),
                      child: Text(
                        "Ver tabla de amortización completa",
                        style: TextStyle(
                            color: darkYellow, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
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
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String groupValue,
    required String label,
    required Function(String?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return darkYellow;
              },
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirstOfEach {
    return split(' ').map((word) {
      return word.length > 0
          ? '${word[0].toUpperCase()}${word.substring(1)}'
          : '';
    }).join(' ');
  }
}
