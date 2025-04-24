import 'package:flutter/material.dart';

class Inflacion extends StatefulWidget {
  const Inflacion({super.key});

  @override
  _InflacionState createState() => _InflacionState();
}

class _InflacionState extends State<Inflacion> {
  final TextEditingController _ipcInicialController = TextEditingController();
  final TextEditingController _ipcFinalController = TextEditingController();
  final TextEditingController _tasasMensualesController =
      TextEditingController();

  double _resultado = 0;
  String _tipoCalculo = 'Inflación Anual';

  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  void _calcular() {
    switch (_tipoCalculo) {
      case 'Inflación Anual':
        _calcularInflacionAnual();
        break;
      case 'Inflación Acumulada':
        _calcularInflacionAcumulada();
        break;
      case 'Inflación Mensual':
        _calcularInflacionMensual();
        break;
    }
    setState(() {});
  }

  void _calcularInflacionAnual() {
    final double ipcInicial = double.tryParse(_ipcInicialController.text) ?? 0;
    final double ipcFinal = double.tryParse(_ipcFinalController.text) ?? 0;
    _resultado = (ipcInicial > 0 && ipcFinal > 0)
        ? ((ipcFinal - ipcInicial) / ipcInicial) * 100
        : 0;
  }

  void _calcularInflacionAcumulada() {
    final tasasStr = _tasasMensualesController.text
        .split(',')
        .map((e) => double.tryParse(e.trim()) ?? 0)
        .toList();
    double tasaAcumulada =
        tasasStr.fold(1, (acc, tasa) => acc * (1 + tasa / 100));
    _resultado = (tasaAcumulada - 1) * 100;
  }

  void _calcularInflacionMensual() {
    final double ipcActual = double.tryParse(_ipcFinalController.text) ?? 0;
    final double ipcAnterior = double.tryParse(_ipcInicialController.text) ?? 0;
    _resultado = (ipcAnterior > 0 && ipcActual > 0)
        ? (((ipcActual / ipcAnterior) - 1) * 100)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: Text(
          'Cálculo de Inflación',
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
                      Icons.trending_up,
                      size: 50,
                      color: Color(0xFFC7A500),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Selector de tipo de cálculo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkYellow.withOpacity(0.5)),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _tipoCalculo,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFFC7A500)),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: textDark),
                    underline: const SizedBox(),
                    items: <String>[
                      'Inflación Anual',
                      'Inflación Acumulada',
                      'Inflación Mensual'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _tipoCalculo = newValue!;
                        _ipcInicialController.clear();
                        _ipcFinalController.clear();
                        _tasasMensualesController.clear();
                        _resultado = 0;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Campos de entrada según el tipo de cálculo
                _buildInputFields(),

                const SizedBox(height: 24),

                // Botón calcular
                Container(
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
                    onPressed: _calcular,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textDark,
                      backgroundColor: primaryYellow,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'CALCULAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Resultado
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkYellow.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Tasa de Inflación',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_resultado.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
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

  Widget _buildInputFields() {
    if (_tipoCalculo == 'Inflación Anual') {
      return Column(
        children: [
          _buildInputField(
            controller: _ipcInicialController,
            label: 'IPC Inicial',
            hint: 'Ingrese el IPC del período anterior',
            icon: Icons.calendar_view_month,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _ipcFinalController,
            label: 'IPC Final',
            hint: 'Ingrese el IPC del período actual',
            icon: Icons.calendar_today,
          ),
        ],
      );
    } else if (_tipoCalculo == 'Inflación Acumulada') {
      return _buildInputField(
        controller: _tasasMensualesController,
        label: 'Tasas Mensuales',
        hint: 'Ingrese tasas separadas por comas (ej: 1.5, 2.0, 1.7)',
        icon: Icons.list,
      );
    } else if (_tipoCalculo == 'Inflación Mensual') {
      return Column(
        children: [
          _buildInputField(
            controller: _ipcInicialController,
            label: 'IPC Anterior',
            hint: 'Ingrese el IPC del mes anterior',
            icon: Icons.arrow_back,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _ipcFinalController,
            label: 'IPC Actual',
            hint: 'Ingrese el IPC del mes actual',
            icon: Icons.arrow_forward,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }

  @override
  void dispose() {
    _ipcInicialController.dispose();
    _ipcFinalController.dispose();
    _tasasMensualesController.dispose();
    super.dispose();
  }
}
