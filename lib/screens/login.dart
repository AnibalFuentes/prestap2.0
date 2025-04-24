import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prestapp/screens/biometric_auth.dart';
import 'package:prestapp/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final BiometricAuth _biometricAuth = BiometricAuth();
  bool _showPasswordLogin = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkDeviceForBiometrics();
  }

  Future<void> _checkDeviceForBiometrics() async {
    bool canCheckBiometrics = await _biometricAuth.canCheckBiometrics();
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (canCheckBiometrics) {
      _authenticateBiometric();
    } else {
      setState(() {
        _showPasswordLogin = true;
      });
    }
  }

  Future<void> _authenticateBiometric() async {
    bool isAuthenticated = await _biometricAuth.authenticateWithBiometrics();
    if (isAuthenticated) {
      Navigator.pushNamed(context, "/");
    } else {
      setState(() {
        _showPasswordLogin = true;
      });
    }
  }

  Future<void> _login() async {
    String cc = _ccController.text;
    String password = _passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCC = prefs.getString('cedula');
    String? storedPassword = prefs.getString('password');

    if (cc == storedCC && password == storedPassword) {
      Navigator.pushNamed(context, "/");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cédula o contraseña incorrecta"),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define PrestApp's brand colors
    final primaryYellow = Color(0xFFFFD700); // Brand yellow
    final darkColor = Color(0xFF333333);
    final lightYellow = Color(0xFFFFF9C4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, lightYellow],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  // Logo and App Name
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryYellow,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: primaryYellow.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.attach_money,
                            size: 70,
                            color: darkColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "PrestApp",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tu solución financiera",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),

                  // Login Form or Biometric Auth Progress
                  if (!_showPasswordLogin) ...[
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryYellow),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Autenticación biométrica en proceso",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showPasswordLogin = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: darkColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                            ),
                            child: Text(
                              "Cancelar autenticación biométrica",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Credentials Login Form
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Cedula Input
                          TextField(
                            controller: _ccController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Cédula",
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon:
                                  Icon(Icons.person, color: primaryYellow),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: primaryYellow, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Password Input
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon:
                                  Icon(Icons.lock, color: primaryYellow),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: primaryYellow, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),

                          SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Forgot password functionality
                              },
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryYellow,
                                foregroundColor: darkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                "INGRESAR",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Register Link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "¿No tienes cuenta? ",
                          style: TextStyle(color: Colors.grey[700]),
                          children: [
                            TextSpan(
                              text: "Regístrate aquí",
                              style: TextStyle(
                                color: darkColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_canCheckBiometrics) ...[
                      SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _authenticateBiometric,
                        icon: Icon(Icons.fingerprint,
                            color: primaryYellow, size: 28),
                        label: Text(
                          "Usar biométricos",
                          style: TextStyle(
                            color: darkColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
