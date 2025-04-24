import 'package:flutter/material.dart';
import 'dart:math';

class Bono {
  final double valorNominal;
  final double tasaCupon;
  final double tasaRendimiento;
  final int anos;
  final int diasDevengados;
  final int periodoCupon;

  Bono({
    required this.valorNominal,
    required this.tasaCupon,
    required this.tasaRendimiento,
    required this.anos,
    required this.diasDevengados,
    required this.periodoCupon,
  });

  double calcularPrecio() {
    double precio = 0.0;
    double pagoCupon = valorNominal * tasaCupon;

    for (int t = 1; t <= anos * (360 / periodoCupon); t++) {
      precio += pagoCupon / pow(1 + tasaRendimiento, t * periodoCupon / 360);
    }

    precio += valorNominal / pow(1 + tasaRendimiento, anos);

    return precio;
  }

  double calcularPrecioSucio() {
    double precioSucio = 0.0;
    double cupon = valorNominal * tasaCupon * periodoCupon / 360;
    int totalCupones = anos * (360 ~/ periodoCupon);

    for (int i = 1; i <= totalCupones; i++) {
      precioSucio += cupon / pow(1 + tasaRendimiento, i * periodoCupon / 360);
    }

    precioSucio += valorNominal /
        pow(1 + tasaRendimiento, totalCupones * periodoCupon / 360);

    return precioSucio;
  }

  double calcularInteresDevengado() {
    double cupon = valorNominal * tasaCupon * periodoCupon / 360;
    return cupon * diasDevengados / 360;
  }

  double calcularPrecioLimpio() {
    return calcularPrecioSucio() - calcularInteresDevengado();
  }
}

class Bonos extends StatefulWidget {
  const Bonos({super.key});

  @override
  _BonosState createState() => _BonosState();
}

class _BonosState extends State<Bonos> {
  final TextEditingController _valorNominalController = TextEditingController();
  final TextEditingController _tasaCuponController = TextEditingController();
  final TextEditingController _tasaRendimientoController =
      TextEditingController();
  final TextEditingController _anosController = TextEditingController();
  final TextEditingController _diasDevengadosController =
      TextEditingController();
  final TextEditingController _periodoCuponController = TextEditingController();

  double _resultado = 0.0;
  String _opcionSeleccionada = 'Precio del Bono';
  final List<String> _opciones = [
    'Precio del Bono',
    'Precio Sucio',
    'Interés Devengado',
    'Precio Limpio'
  ];

  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  void _calcularValores() {
    final valorNominal = double.tryParse(_valorNominalController.text);
    final tasaCupon = double.tryParse(_tasaCuponController.text)! / 100;
    final tasaRendimiento =
        double.tryParse(_tasaRendimientoController.text)! / 100;
    final anos = int.tryParse(_anosController.text);
    final diasDevengados = int.tryParse(_diasDevengadosController.text);
    final periodoCupon = int.tryParse(_periodoCuponController.text);

    if (valorNominal != null &&
        anos != null &&
        diasDevengados != null &&
        periodoCupon != null) {
      final bono = Bono(
        valorNominal: valorNominal,
        tasaCupon: tasaCupon,
        tasaRendimiento: tasaRendimiento,
        anos: anos,
        diasDevengados: diasDevengados,
        periodoCupon: periodoCupon,
      );

      setState(() {
        switch (_opcionSeleccionada) {
          case 'Precio del Bono':
            _resultado = bono.calcularPrecio();
            break;
          case 'Precio Sucio':
            _resultado = bono.calcularPrecioSucio();
            break;
          case 'Interés Devengado':
            _resultado = bono.calcularInteresDevengado();
            break;
          case 'Precio Limpio':
            _resultado = bono.calcularPrecioLimpio();
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: const Text(
          'Cálculo de Bonos',
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDE7), Colors.white],
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
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: primaryYellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on_outlined,
                      size: 60,
                      color: Color(0xFFC7A500),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Título
                const Text(
                  'Calculadora de Bonos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),

                const SizedBox(height: 8),

                // Subtítulo
                const Text(
                  'Complete los datos del bono y seleccione qué desea calcular',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Campos de entrada
                _buildInputField(
                  controller: _valorNominalController,
                  label: 'Valor Nominal del Bono (\$)',
                  icon: Icons.attach_money,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _tasaCuponController,
                  label: 'Tasa de Cupón (%)',
                  icon: Icons.percent,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _tasaRendimientoController,
                  label: 'Tasa de Rendimiento Requerida (%)',
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _anosController,
                  label: 'Años hasta el Vencimiento',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _diasDevengadosController,
                  label: 'Días Devengados',
                  icon: Icons.timer,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: _periodoCuponController,
                  label: 'Período del Cupón (días)',
                  icon: Icons.date_range,
                ),
                const SizedBox(height: 24),

                // Selector de opción
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: darkYellow.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _opcionSeleccionada,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFFC7A500)),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF212121)),
                    underline: const SizedBox(),
                    items: _opciones.map((String opcion) {
                      return DropdownMenuItem<String>(
                        value: opcion,
                        child: Text(opcion),
                      );
                    }).toList(),
                    onChanged: (String? nuevaOpcion) {
                      setState(() {
                        _opcionSeleccionada = nuevaOpcion!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 32),

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
                    onPressed: _calcularValores,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textDark,
                      backgroundColor: primaryYellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkYellow.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Resultado:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_resultado.toStringAsFixed(2)}',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkYellow),
        ),
        prefixIcon: Icon(icon, color: darkYellow),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
