import 'package:flutter/material.dart';

class AmortizacionView extends StatelessWidget {
  const AmortizacionView({super.key});

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
          "Sistemas de Amortización",
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
                      Icons.graphic_eq,
                      size: 60,
                      color: darkYellow,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Texto principal
                const Text(
                  "Seleccione el sistema de amortización",
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
                  "Elija el método para calcular su préstamo",
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
                  icon: Icons.equalizer,
                  label: "Sistema Francés",
                  description: "Cuotas constantes durante todo el plazo",
                  route: "/amortizacion/francesa",
                  color: primaryYellow,
                  textColor: textDark,
                ),

                const SizedBox(height: 16),

                _buildOptionButton(
                  context: context,
                  icon: Icons.trending_down,
                  label: "Sistema Alemán",
                  description:
                      "Amortización constante con intereses decrecientes",
                  route: "/amortizacion/alemana",
                  color: primaryYellow,
                  textColor: textDark,
                ),

                const SizedBox(height: 16),

                _buildOptionButton(
                  context: context,
                  icon: Icons.money_off,
                  label: "Sistema Americano",
                  description:
                      "Pago de intereses periódicos y capital al final",
                  route: "/amortizacion/americana",
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
