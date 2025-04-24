import 'package:flutter/material.dart';
import 'package:prestapp/screens/amortizacion/alemana/services/calcularAlemana.dart';

class AlemanaView extends StatefulWidget {
  const AlemanaView({super.key});

  @override
  State<AlemanaView> createState() => _AlemanaState();
}

class _AlemanaState extends State<AlemanaView> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoprestamo = TextEditingController();
  final TextEditingController _tasaInteresAnual = TextEditingController();
  final TextEditingController _plazoMeses = TextEditingController();

  List<Map<String, double>>? _amortizationTable;
  String _frecuenciaSeleccionada = 'Anual';
  final Map<String, int> _opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12
  };

  final Calcularalemana _calculator = Calcularalemana();

  void _calculateAmortization() {
    if (_formKey.currentState!.validate()) {
      final double montoPrestamo = double.parse(_montoprestamo.text);
      final double tasaInteresAnual = double.parse(_tasaInteresAnual.text);
      final int plazoMeses = int.parse(_plazoMeses.text);

      setState(() {
        _amortizationTable = _calculator.calculateFutureAmount(
          montoPrestamo: montoPrestamo,
          plazoMeses: plazoMeses,
          tasaInteresAnual: tasaInteresAnual,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          'Amortización Alemana',
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
              child: Form(
                key: _formKey,
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
                          Icons.account_balance,
                          size: 40,
                          color: darkYellow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sección de parámetros
                    _buildSectionTitle("Parámetros del préstamo"),
                    const SizedBox(height: 16),

                    // Campos de entrada de datos
                    _buildInputField(
                      controller: _montoprestamo,
                      label: "Monto del Préstamo",
                      icon: Icons.attach_money,
                      hint: 'Ej. 10000',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _tasaInteresAnual,
                      label: "Tasa de Interés Anual (%)",
                      icon: Icons.percent,
                      hint: 'Ej. 12.5',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _plazoMeses,
                      label: "Plazo en Meses",
                      icon: Icons.calendar_today,
                      hint: 'Ej. 36',
                    ),
                    const SizedBox(height: 16),

                    // Selector de frecuencia
                    _buildDropdown(
                      value: _frecuenciaSeleccionada,
                      items: _opcionesFrecuencia.keys.toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _frecuenciaSeleccionada = newValue!;
                        });
                      },
                      prefixIcon: Icons.repeat,
                      hintText: "Frecuencia de pagos",
                    ),
                    const SizedBox(height: 32),

                    // Botón de cálculo
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _calculateAmortization,
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
                              "CALCULAR AMORTIZACIÓN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tabla de amortización
                    if (_amortizationTable != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Tabla de Amortización",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.5,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(label: Text('Periodo')),
                                    DataColumn(label: Text('Cuota')),
                                    DataColumn(label: Text('Capital')),
                                    DataColumn(label: Text('Interés')),
                                    DataColumn(label: Text('Saldo')),
                                  ],
                                  rows: _amortizationTable!.map((cuota) {
                                    return DataRow(cells: [
                                      DataCell(Text(cuota['Periodo']?.toInt().toString() ?? '0')),
                                      DataCell(Text('\$${cuota['Cuota']?.toStringAsFixed(2) ?? '0.00'}')),
                                      DataCell(Text('\$${cuota['Capital']?.toStringAsFixed(2) ?? '0.00'}')),
                                      DataCell(Text('\$${cuota['Intereses']?.toStringAsFixed(2) ?? '0.00'}')),
                                      DataCell(Text('\$${cuota['Saldo']?.toStringAsFixed(2) ?? '0.00'}')),
                                    ]);
                                  }).toList(),
                                ),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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