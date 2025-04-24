import 'package:flutter/material.dart';

class SimpleView extends StatelessWidget {
  const SimpleView({super.key});

  @override
  Widget build(BuildContext context) {
    // Definir colores para el tema de la aplicación
    const Color primaryYellow = Color(0xFFFFD600);
    const Color darkYellow = Color(0xFFC7A500);
    const Color textDark = Color(0xFF212121);
    const Color backgroundColor = Color(0xFFFFFDE7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: const Text(
          "Calculadora de Préstamos",
          style: TextStyle(
            color: textDark,
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
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen o icono
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: primaryYellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calculate_outlined,
                      size: 60,
                      color: darkYellow,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Texto principal
                const Text(
                  "¿Qué desea calcular?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtítulo
                const Text(
                  "Seleccione una opción para iniciar el cálculo",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Botones con diseño mejorado
                _buildOptionButton(
                  context: context,
                  icon: Icons.attach_money,
                  label: "Calcular Monto",
                  description: "Determina el capital final o préstamo",
                  route: "/simple/form",
                  color: primaryYellow,
                  textColor: textDark,
                ),

                const SizedBox(height: 16),

                _buildOptionButton(
                  context: context,
                  icon: Icons.percent,
                  label: "Calcular Tasa de Interés",
                  description: "Encuentra la tasa óptima para tu préstamo",
                  route: "/simple/interes",
                  color: primaryYellow,
                  textColor: textDark,
                ),

                const SizedBox(height: 16),

                _buildOptionButton(
                  context: context,
                  icon: Icons.calendar_today,
                  label: "Calcular Tiempo",
                  description: "Determina la duración del préstamo",
                  route: "/simple/tiempo",
                  color: primaryYellow,
                  textColor: textDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required String route,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
