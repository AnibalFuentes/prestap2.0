import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/RetirosScreen.dart';
import 'package:ingeconomica/screens/alternativa_inversion/views/evaluacion_alternativa_inversion_views.dart';
import 'package:ingeconomica/screens/pagos/pagos.dart';
import 'package:ingeconomica/screens/prestamos/prestamos.dart';
import 'package:ingeconomica/screens/unidad_valor_real/views/unidad_valor_real_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ingeconomica/screens/amortizacion/view/amortizacion_view.dart';
import 'package:ingeconomica/screens/aritmetico/views/aritmetico_views.dart';
import 'package:ingeconomica/screens/bonos/views/bonos.dart';
import 'package:ingeconomica/screens/compuesto/view/compuesto_view.dart';
import 'package:ingeconomica/screens/gradiente_geometrico/view/GeometricOptionsForm.dart';
import 'package:ingeconomica/screens/inflacion/view/inflacion.dart';
import 'package:ingeconomica/screens/simple/services/interes_calculator.dart';
import 'package:ingeconomica/screens/simple/view/simple_view.dart';
import 'package:ingeconomica/screens/tir/view/tir_form.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final double initialAmount;

  const HomeScreen({
    super.key,
    required this.username,
    required this.initialAmount,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedOptionIndex = 0;
  double currentAmount = 0;
  List<String> transactions = [];

  // Define PrestApp's brand colors
  final primaryYellow = Color(0xFFFFD700);
  final darkColor = Color(0xFF333333);
  final lightYellow = Color(0xFFFFF9C4);
  final accentYellow = Color(0xFFFFCC00);

  @override
  void initState() {
    super.initState();
    loadAmount();
    loadTransactions();
  }

  Future<void> loadAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentAmount = prefs.getDouble('amount') ?? widget.initialAmount;
    });
  }

  Future<void> saveAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amount', currentAmount);
  }

  Future<void> loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      transactions = prefs.getStringList('transactions') ?? [];
    });
  }

  Future<void> saveTransaction(String transaction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    transactions.add(transaction);
    await prefs.setStringList('transactions', transactions);
  }

  void makeLoan(double amount) {
    setState(() {
      currentAmount += amount;
      saveAmount();
      saveTransaction('Préstamo de \$${amount.toStringAsFixed(2)}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Préstamo por \$${amount.toStringAsFixed(2)} aprobado!'),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void makePayment(double amount) {
    setState(() {
      currentAmount -= amount;
      saveAmount();
      saveTransaction('Pago de \$${amount.toStringAsFixed(2)}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '¡Pago de \$${amount.toStringAsFixed(2)} realizado con éxito!'),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedOptionIndex = 0;
    });
  }

  void _onOptionTapped(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InterestCalculator calculator = InterestCalculator();

    List<Widget> listOptions = [
      buildMainMenu(context, calculator),
      const SimpleView(),
      const CompuestoView(),
      const GeometricOptionsForm(),
      const AritmeticoView(),
      const AmortizacionView(),
      const Bonos(),
      const Inflacion(),
      TIRView(),
      const UnidadValorRealView(),
      const EvaluacionAlternativaInversionView(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedOptionIndex != 0) {
          setState(() {
            _selectedOptionIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, lightYellow],
            ),
          ),
          child: SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                IndexedStack(
                  index: _selectedOptionIndex,
                  children: listOptions,
                ),
                buildMovimientosScreen(),
                buildServiciosScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Movimientos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Servicios',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: darkColor,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: primaryYellow,
            elevation: 0,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildMainMenu(BuildContext context, InterestCalculator calculator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenido a",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    "PrestApp",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: primaryYellow,
                child: Icon(
                  Icons.person,
                  color: darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          buildBalanceCard(calculator),
          const SizedBox(height: 25),
          Text(
            "Herramientas Financieras",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                buildGridItem(context, "I. Simple", Icons.money, 1),
                buildGridItem(context, "I. Compuesto", Icons.trending_up, 2),
                buildGridItem(context, "G. Geométrico", Icons.pie_chart, 3),
                buildGridItem(context, "G. Aritmético", Icons.calculate, 4),
                buildGridItem(context, "Amortización", Icons.history, 5),
                buildGridItem(context, "Bonos", Icons.attach_money, 6),
                buildGridItem(context, "Inflación", Icons.trending_down, 7),
                buildGridItem(context, "TIR", Icons.trending_up, 8),
                buildGridItem(
                    context, "U.V.R", Icons.monetization_on_outlined, 9),
                buildGridItem(
                    context, "E.A.I", Icons.account_balance_outlined, 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBalanceCard(InterestCalculator calculator) {
    return Card(
      elevation: 8,
      shadowColor: primaryYellow.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryYellow,
              accentYellow,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: darkColor, size: 24),
                SizedBox(width: 10),
                Text(
                  "Saldo Disponible",
                  style: TextStyle(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '\$${calculator.formatNumber(currentAmount)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildQuickActionButton(
                  "Préstamo",
                  Icons.trending_up_rounded,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanWidget(
                          onLoanMade: (double loanAmount) {
                            makeLoan(loanAmount);
                          },
                        ),
                      ),
                    );
                  },
                ),
                buildQuickActionButton(
                  "Pago",
                  Icons.payment_rounded,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pagos(
                          saldoDisponible: currentAmount,
                          onPagoRealizado: (double pago, String descripcion) {
                            makePayment(pago);
                          },
                        ),
                      ),
                    );
                  },
                ),
                buildQuickActionButton(
                  "Retiro",
                  Icons.logout_rounded,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RetirosScreen(
                          onRetiroRealizado: (double retiroAmount) {
                            setState(() {
                              currentAmount -= retiroAmount;
                              saveAmount();
                              saveTransaction(
                                  'Retiro de \$${retiroAmount.toStringAsFixed(2)}');
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickActionButton(
      String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: darkColor, size: 18),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: darkColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMovimientosScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Historial de Movimientos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          Text(
            'Tus transacciones recientes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),

          // Search bar for transactions
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar transacciones',
                prefixIcon: Icon(Icons.search, color: primaryYellow),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildFilterChip('Todos', true),
                buildFilterChip('Préstamos', false),
                buildFilterChip('Pagos', false),
                buildFilterChip('Retiros', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 70,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay transacciones',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tus transacciones aparecerán aquí',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      // Reverse order to show newest first
                      String transaction =
                          transactions[transactions.length - 1 - index];
                      RegExp regExp = RegExp(r'(\d+\.?\d*)');
                      Match? match = regExp.firstMatch(transaction);

                      if (match != null) {
                        String amountString = match.group(0)!;
                        double amount = double.parse(amountString);
                        String transactionType =
                            transaction.split(' ')[0]; // Obtener tipo

                        // Icons and colors
                        IconData transactionIcon;
                        Color iconBgColor;
                        Color amountColor;

                        switch (transactionType) {
                          case 'Préstamo':
                            transactionIcon = Icons.trending_up;
                            iconBgColor = Colors.green[100]!;
                            amountColor = Colors.green[700]!;
                            break;
                          case 'Pago':
                            transactionIcon = Icons.payment;
                            iconBgColor = Colors.red[100]!;
                            amountColor = Colors.red[700]!;
                            break;
                          case 'Retiro':
                            transactionIcon = Icons.logout;
                            iconBgColor = Colors.orange[100]!;
                            amountColor = Colors.orange[700]!;
                            break;
                          default:
                            transactionIcon = Icons.receipt;
                            iconBgColor = Colors.blue[100]!;
                            amountColor = Colors.blue[700]!;
                        }

                        String formattedAmount = amount.toStringAsFixed(0);
                        String formattedDate =
                            '${DateTime.now().day}/${DateTime.now().month}';

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: iconBgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(transactionIcon, color: amountColor),
                            ),
                            title: Text(
                              transactionType,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'Fecha: $formattedDate',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            trailing: Text(
                              '\$$formattedAmount',
                              style: TextStyle(
                                color: amountColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Implement filter logic
        },
        selectedColor: primaryYellow,
        checkmarkColor: darkColor,
        labelStyle: TextStyle(
          color: isSelected ? darkColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget buildServiciosScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Servicios PrestApp',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          Text(
            'Gestiona tus finanzas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),

          // Featured service card
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryYellow, accentYellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryYellow.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.attach_money,
                    size: 150,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Préstamo Rápido",
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Obtén financiamiento inmediato\nsin complicaciones",
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanWidget(
                                onLoanMade: (double loanAmount) {
                                  makeLoan(loanAmount);
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: darkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: Text(
                          "SOLICITAR AHORA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Text(
            'Todos los servicios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 16),

          // Services list
          Expanded(
            child: ListView(
              children: [
                buildServiceCard(
                  'Préstamos',
                  Icons.trending_up_rounded,
                  'Solicita fondos de forma rápida',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanWidget(
                          onLoanMade: (double loanAmount) {
                            makeLoan(loanAmount);
                          },
                        ),
                      ),
                    );
                  },
                ),
                buildServiceCard(
                  'Pagos',
                  Icons.payment_rounded,
                  'Realiza pagos y transferencias',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pagos(
                          saldoDisponible: currentAmount,
                          onPagoRealizado: (double pago, String descripcion) {
                            makePayment(pago);
                          },
                        ),
                      ),
                    );
                  },
                ),
                buildServiceCard(
                  'Retiros',
                  Icons.logout_rounded,
                  'Retira fondos a tu cuenta',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RetirosScreen(
                          onRetiroRealizado: (double retiroAmount) {
                            setState(() {
                              currentAmount -= retiroAmount;
                              saveAmount();
                              saveTransaction(
                                  'Retiro de \$${retiroAmount.toStringAsFixed(2)}');
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                buildServiceCard(
                  'Calculadoras Financieras',
                  Icons.calculate_rounded,
                  'Herramientas para tus finanzas',
                  () {
                    _onItemTapped(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServiceCard(
      String title, IconData icon, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryYellow,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(
      BuildContext context, String title, IconData icon, int optionIndex) {
    return GestureDetector(
      onTap: () {
        _onOptionTapped(optionIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: primaryYellow,
                size: 25,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: darkColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
