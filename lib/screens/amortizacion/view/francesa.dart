import 'package:flutter/material.dart';
import 'package:prestapp/screens/amortizacion/francesa/services/calcularFrancesar.dart';

class Francesa extends StatefulWidget {
  const Francesa({super.key});

  @override
  State<Francesa> createState() => _FrancesaState();
}

class _FrancesaState extends State<Francesa> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoprestamo = TextEditingController();
  final TextEditingController _tasaInteresAnual = TextEditingController();
  final TextEditingController _plazoMeses = TextEditingController();

  double? _cuotaMensual;
  String _frecuenciaSeleccionada = 'Mensual';
  final Map<String, int> _opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12
  };

  final Calcularfrancesar _calculator = Calcularfrancesar();

  void _calculateCuota() {
    if (_formKey.currentState!.validate()) {
      final double montoPrestamo = double.parse(_montoprestamo.text);
      final double tasaInteresAnual = double.parse(_tasaInteresAnual.text);
      final int plazoMeses = int.parse(_plazoMeses.text);

      setState(() {
        _cuotaMensual = _calculator.calculateFutureAmount(
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
          'Amortización Francesa',
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
                          Icons.euro_symbol,
                          size: 40,
                          color: darkYellow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sección de parámetros
                    _buildSectionTitle("Datos del préstamo"),
                    const SizedBox(height: 16),

                    // Campos de entrada de datos
                    _buildInputField(
                      controller: _montoprestamo,
                      label: "Monto del préstamo",
                      icon: Icons.attach_money,
                      hint: 'Ej. 10000',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _tasaInteresAnual,
                      label: "Tasa de interés anual (%)",
                      icon: Icons.percent,
                      hint: 'Ej. 12.5',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _plazoMeses,
                      label: "Plazo en meses",
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
                        onPressed: _calculateCuota,
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
                              "CALCULAR CUOTA",
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

                    // Resultado del cálculo
                    if (_cuotaMensual != null)
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
                              "Cuota mensual calculada",
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
                                  _calculator.formatNumber(_cuotaMensual!),
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
                              "Frecuencia: $_frecuenciaSeleccionada",
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
