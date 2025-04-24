import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Pagos extends StatefulWidget {
  final double saldoDisponible;
  final Function(double pago, String descripcion) onPagoRealizado;

  const Pagos(
      {super.key,
      required this.saldoDisponible,
      required this.onPagoRealizado});

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  final _formKey = GlobalKey<FormState>();
  double cuota = 0.0;
  String descripcion = '';
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _mostrarNotificacion(double cantidad) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'pagos_channel',
      'Notificaciones de Pagos',
      importance: Importance.max,
      priority: Priority.high,
      colorized: true,
      color: Color(0xFFFFD600),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Pago realizado ✅',
      'Has pagado \$${cantidad.toStringAsFixed(2)}',
      platformChannelSpecifics,
    );
  }

  Future<void> _pagarCuota() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (cuota <= widget.saldoDisponible) {
        try {
          final bool isAuthenticated = await auth.authenticate(
            localizedReason: 'Autentícate para confirmar el pago',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
          );

          if (isAuthenticated) {
            widget.onPagoRealizado(cuota, descripcion);
            await _mostrarNotificacion(cuota);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Pago realizado con éxito'),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en autenticación: ${e.toString()}'),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Saldo insuficiente para realizar el pago'),
            backgroundColor: Colors.orange[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
          'Realizar Pago',
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
            child: Form(
              key: _formKey,
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
                        Icons.payment,
                        size: 50,
                        color: Color(0xFFC7A500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Saldo disponible
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: darkYellow.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Saldo Disponible',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${widget.saldoDisponible.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Formulario de pago
                  _buildInputField(
                    label: 'Monto a pagar',
                    hint: 'Ingrese el monto de la cuota',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un monto';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Ingrese un número válido';
                      }
                      if (amount <= 0) {
                        return 'El monto debe ser mayor a cero';
                      }
                      return null;
                    },
                    onSaved: (value) => cuota = double.parse(value!),
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Descripción (opcional)',
                    hint: 'Ej: Pago de cuota mensual',
                    icon: Icons.description,
                    validator: null,
                    onSaved: (value) => descripcion = value ?? '',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 32),

                  // Botón de pago
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
                      onPressed: _pagarCuota,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: textDark,
                        backgroundColor: primaryYellow,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CONFIRMAR PAGO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: darkYellow.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: darkYellow,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              icon,
              color: darkYellow,
            ),
          ),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
