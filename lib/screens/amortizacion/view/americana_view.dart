import 'package:flutter/material.dart';
import 'package:prestapp/screens/amortizacion/americana/services/calcular_americana.dart';

class AmericaView extends StatefulWidget {
  const AmericaView({Key? key}) : super(key: key);

  @override
  _AmericaViewState createState() => _AmericaViewState();
}

class _AmericaViewState extends State<AmericaView> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _aniosController = TextEditingController();

  double? _interesMensual;
  double? _totalIntereses;
  double? _ultimoPago;

  void _calcularAmortizacion() {
    if (_formKey.currentState!.validate()) {
      double principal = double.parse(_principalController.text);
      double tasaInteresAnual = double.parse(_tasaController.text);
      int anios = int.parse(_aniosController.text);

      CalcularAmericana calculadora = CalcularAmericana(
        principal: principal,
        tasaInteresAnual: tasaInteresAnual,
        anios: anios,
      );

      var resultado = calculadora.calcularAmortizacion();

      setState(() {
        _interesMensual = resultado['interesMensual'];
        _totalIntereses = resultado['totalIntereses'];
        _ultimoPago = resultado['ultimoPago'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text(
          'Amortización Americana',
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
                          Icons.flag,
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
                      controller: _principalController,
                      label: "Monto del préstamo",
                      icon: Icons.attach_money,
                      hint: 'Ej. 10000',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _tasaController,
                      label: "Tasa de interés anual (%)",
                      icon: Icons.percent,
                      hint: 'Ej. 12.5',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _aniosController,
                      label: "Duración (años)",
                      icon: Icons.calendar_today,
                      hint: 'Ej. 5',
                    ),
                    const SizedBox(height: 32),

                    // Botón de cálculo
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _calcularAmortizacion,
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

                    // Resultados
                    if (_interesMensual != null)
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Resultados de la amortización",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildResultRow(
                                "Interés mensual:", _interesMensual!),
                            _buildResultRow(
                                "Total de intereses:", _totalIntereses!),
                            _buildResultRow("Último pago:", _ultimoPago!),
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

  // Widget para mostrar resultados
  Widget _buildResultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: textDark.withOpacity(0.8),
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }
}
