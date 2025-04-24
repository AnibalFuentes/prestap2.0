import 'package:flutter/material.dart';
import 'package:prestapp/screens/alternativa_inversion/services/calculo_eai.dart';

class EvaluacionAlternativaInversionVPN extends StatefulWidget {
  const EvaluacionAlternativaInversionVPN({super.key});

  @override
  EvaluacionAlternativaInversionVPNState createState() =>
      EvaluacionAlternativaInversionVPNState();
}

class EvaluacionAlternativaInversionVPNState
    extends State<EvaluacionAlternativaInversionVPN> {
  // Definición de colores para el tema amarillo
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color lightYellow = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF212121);

  final TextEditingController _valorFCController = TextEditingController();
  final TextEditingController _valorIController = TextEditingController();
  final TextEditingController _tasaDController = TextEditingController();
  double? _eAIResult;
  String _selectedOption2 = "Valor Presente Neto";
  String _answerText = "Valor Presente Neto";
  List<double> fcaja = [];
  final EAICalculator _calculator = EAICalculator();

  void _calculateEAI() {
    if (_valorIController.text.isNotEmpty &&
        _tasaDController.text.isNotEmpty &&
        fcaja.isNotEmpty) {
      final double invInicial = double.parse(_valorIController.text);
      final double tasadescuento = double.parse(_tasaDController.text);

      if (_selectedOption2 == "Valor Presente Neto") {
        setState(() {
          _answerText = _selectedOption2;
          _eAIResult = _calculator.calcularVPN(
              fcaja: fcaja,
              tasadescuento: tasadescuento,
              invInicial: invInicial);
        });
      } else {
        final double vpn = _calculator.calcularVPN(
            fcaja: fcaja, tasadescuento: tasadescuento, invInicial: invInicial);
        setState(() {
          _answerText = _selectedOption2;
          _eAIResult =
              _calculator.calculateIR(vpn: vpn, invInicial: invInicial);
        });
      }
    }
  }

  void _addFlujoCaja() {
    if (_valorFCController.text.isNotEmpty &&
        double.parse(_valorFCController.text) > 0) {
      setState(() {
        fcaja.add(double.parse(_valorFCController.text));
        _valorFCController.text = "";
      });
    }
  }

  void _removeFlujoCaja(int index) {
    setState(() {
      fcaja.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: Text(
          'Valor Presente Neto / Índice Rentabilidad',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textDark,
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
                      Icons.monetization_on,
                      size: 40,
                      color: darkYellow,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Selector de tipo de cálculo
                _buildDropdown(
                  value: _selectedOption2,
                  items: ['Valor Presente Neto', 'Índice de Rentabilidad'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption2 = newValue!;
                    });
                  },
                  prefixIcon: Icons.calculate,
                  hintText: "Tipo de cálculo",
                ),
                const SizedBox(height: 24),

                // Sección de flujos de caja
                _buildSectionTitle("Flujos de Caja"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildInputField(
                        controller: _valorFCController,
                        label: "Valor Flujo",
                        icon: Icons.payment,
                        hint: 'Ej. 2500',
                        isSmall: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _addFlujoCaja,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryYellow,
                          foregroundColor: textDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Añadir"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de flujos de caja
                if (fcaja.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryYellow),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          "Flujos Registrados",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.2,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: fcaja.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key('$index-${fcaja[index]}'),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (direction) =>
                                    _removeFlujoCaja(index),
                                child: Card(
                                  color: lightYellow,
                                  child: ListTile(
                                    title: Text(
                                      'Periodo ${index + 1}: \$${fcaja[index].toStringAsFixed(2)}',
                                      style: TextStyle(color: textDark),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.close, color: darkYellow),
                                      onPressed: () => _removeFlujoCaja(index),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Sección de parámetros
                _buildSectionTitle("Parámetros de Cálculo"),
                const SizedBox(height: 16),

                // Campos de entrada de datos
                _buildInputField(
                  controller: _valorIController,
                  label: "Inversión Inicial",
                  icon: Icons.attach_money,
                  hint: 'Ej. 10000',
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _tasaDController,
                  label: "Tasa de Descuento (%)",
                  icon: Icons.percent,
                  hint: 'Ej. 12.5',
                ),
                const SizedBox(height: 32),

                // Botón de cálculo
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateEAI,
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
                          "CALCULAR ${_selectedOption2.toUpperCase()}",
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

                // Resultado del cálculo
                if (_eAIResult != null)
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
                          _answerText.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
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
                              _eAIResult!.toStringAsFixed(4),
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
                          _selectedOption2 == "Valor Presente Neto"
                              ? "Valor Presente Neto"
                              : "Índice de Rentabilidad",
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
