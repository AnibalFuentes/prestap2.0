import 'package:flutter/material.dart';
import 'package:prestapp/screens/alternativa_inversion/views/eai_pri.dart';
import 'package:prestapp/screens/alternativa_inversion/views/eai_vpn.dart';
import 'package:prestapp/screens/alternativa_inversion/views/evaluacion_alternativa_inversion_views.dart';
import 'package:prestapp/screens/amortizacion/view/alemana_view.dart';
import 'package:prestapp/screens/amortizacion/view/americana_view.dart';
import 'package:prestapp/screens/amortizacion/view/amortizacion_view.dart';
import 'package:prestapp/screens/amortizacion/view/francesa.dart';
import 'package:prestapp/screens/aritmetico/views/aritmetico_cuota_especifica.dart';
import 'package:prestapp/screens/aritmetico/views/aritmetico_presente.dart';
import 'package:prestapp/screens/aritmetico/views/aritmetico_presente_infinito.dart';
import 'package:prestapp/screens/aritmetico/views/aritmetico_views.dart';
import 'package:prestapp/screens/aritmetico/views/gradiente_aritmetico_futuro.dart';
import 'package:prestapp/screens/bonos/views/bonos.dart';
import 'package:prestapp/screens/compuesto/view/compuesto_view.dart';
import 'package:prestapp/screens/compuesto/view/montofuturo.dart';
import 'package:prestapp/screens/compuesto/view/tasaInteres.dart';
import 'package:prestapp/screens/compuesto/view/tiempo.dart';
import 'package:prestapp/screens/home_screen.dart';
import 'package:prestapp/screens/inflacion/view/inflacion.dart';
import 'package:prestapp/screens/login.dart';
import 'package:prestapp/screens/pagos/pagos.dart';
import 'package:prestapp/screens/register.dart';
import 'package:prestapp/screens/simple/view/simple_forms.dart';
import 'package:prestapp/screens/simple/view/simple_interes.dart';
import 'package:prestapp/screens/simple/view/simple_tiempo.dart';
import 'package:prestapp/screens/simple/view/simple_view.dart';
import 'package:prestapp/screens/gradiente_geometrico/view/geometric_value_calculator.dart';
import 'package:prestapp/screens/gradiente_geometrico/view/geometric_series_calculator.dart';
import 'package:prestapp/screens/unidad_valor_real/views/unidad_valor_real_views.dart';
import 'package:prestapp/screens/unidad_valor_real/views/uvr_form.dart';
import 'package:prestapp/screens/unidad_valor_real/views/uvr_table.dart';
import 'package:prestapp/screens/tir/view/tir_form.dart';

var routes = <String, WidgetBuilder>{
  "/": (_) => const HomeScreen(
        username: "David Coronel",
        initialAmount: 10000000,
      ),
  "/bonos": (_) => const Bonos(),
  "/login": (_) => const Login(),
  "/register": (_) => const Register(),
  "/simple": (_) => const SimpleView(),
  "/simple/form": (_) => const SimpleForms(),
  "/simple/interes": (_) => const SimpleInteres(),
  "/simple/tiempo": (_) => const SimpleTiempo(),
  "/compuesto": (_) => const CompuestoView(),
  "/compuesto/montofuturo": (_) => const Montofuturo(),
  "/compuesto/tasainteres": (_) => const TasaInteres(),
  "/compuesto/tiempo": (_) => const Tiempo(),
  "/amortizacion": (_) => const AmortizacionView(),
  "/amortizacion/francesa": (_) => const Francesa(),
  "/amortizacion/alemana": (_) => const AlemanaView(),
  "/amortizacion/americana": (_) => AmericaView(),
  "/inflacion": (_) => const Inflacion(),
  "/tir": (_) => TIRView(),
  "/aritmetico": (_) => const AritmeticoView(),
  "/aritmetico/valorpresente": (_) => const ValorPresente(),
  "/aritmetico/valorfuturo": (_) => const ValorFuturo(),
  "/aritmetico/valorpresenteinfinito": (_) => const ValorPresenteInfinito(),
  "/aritmetico/cuotaespecifica": (_) => const CuotaEspecifica(),
  "/geometric/value": (_) => const GeometricValueCalculator(),
  "/geometric/series": (_) => const GeometricSeriesCalculator(),
  "/unidadvalorreal": (_) => const UnidadValorRealView(),
  "/unidadvalorreal/valor": (_) => const UnidadValorReal(),
  "/unidadvalorreal/tabla": (_) => const UnidadValorRealTabla(),
  "/evaluacionai": (_) => const EvaluacionAlternativaInversionView(),
  "/evaluacionai/vpn_ir": (_) => const EvaluacionAlternativaInversionVPN(),
  "/evaluacionai/pri": (_) => const EvaluacionAlternativaInversionPRIAR(),
};
