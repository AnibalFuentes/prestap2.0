import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RetirosScreen extends StatefulWidget {
  final Function(double) onRetiroRealizado;

  const RetirosScreen({super.key, required this.onRetiroRealizado});

  @override
  _RetirosScreenState createState() => _RetirosScreenState();
}

class _RetirosScreenState extends State<RetirosScreen> {
  // Colores del tema
  final Color primaryYellow = const Color(0xFFFFD600);
  final Color darkYellow = const Color(0xFFC7A500);
  final Color textDark = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFFFFDE7);

  final TextEditingController _montoController = TextEditingController();
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

  Future<void> _mostrarNotificacion(String cantidad) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'retiros_channel',
      'Notificaciones de Retiros',
      importance: Importance.max,
      priority: Priority.high,
      colorized: true,
      color: Color(0xFFFFD600),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Retiro realizado ✅',
      'Has retirado \$$cantidad',
      platformChannelSpecifics,
    );
  }

  Future<void> _retirarDinero() async {
    try {
      final bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Autentícate para confirmar el retiro',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        final String cantidadStr = _montoController.text;
        final double? cantidad = double.tryParse(cantidadStr);

        if (cantidad == null || cantidad <= 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ingresa una cantidad válida mayor a cero'),
              backgroundColor: Colors.orange[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }

        widget.onRetiroRealizado(cantidad);
        await _mostrarNotificacion(cantidadStr);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Retiro realizado con éxito'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Autenticación requerida para el retiro'),
            backgroundColor: Colors.red[600],
          ),
        );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: const Text(
          'Retirar Dinero',
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
                      Icons.money_off,
                      size: 60,
                      color: Color(0xFFC7A500),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Título
                const Text(
                  'Retiro de Fondos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtítulo
                const Text(
                  'Ingrese el monto que desea retirar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),

                // Campo de monto
                TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monto a retirar',
                    hintText: 'Ingrese la cantidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: darkYellow.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: darkYellow),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.attach_money, color: darkYellow),
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 32),

                // Botón de confirmación
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
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 24),
                    label: const Text(
                      'CONFIRMAR RETIRO',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _retirarDinero,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textDark,
                      backgroundColor: primaryYellow,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
