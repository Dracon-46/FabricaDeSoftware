import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/usuarios_provider.dart';
import 'providers/projetos_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/contribuidores_provider.dart';
import 'providers/recursos_provider.dart';
import 'providers/requisitos_provider.dart';
import 'providers/tecnologias_provider.dart';
import 'providers/testes_provider.dart';
import 'providers/treinamentos_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/usuarios/usuarios_screen.dart';
import 'screens/clientes/clientes_screen.dart';
import 'screens/projetos/projetos_screen.dart';
import 'screens/contribuidores/contribuidores_screen.dart';
import 'screens/recursos/recursos_screen.dart';
import 'screens/requisitos/requisitos_screen.dart';
import 'screens/tecnologias/tecnologias_screen.dart';
import 'screens/testes/testes_screen.dart';
import 'screens/treinamentos/treinamentos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
        ChangeNotifierProvider(create: (_) => ProjetosProvider()),
        ChangeNotifierProvider(create: (_) => ClientesProvider()),
        ChangeNotifierProvider(create: (_) => ContribuidoresProvider()),
        ChangeNotifierProvider(create: (_) => RecursosProvider()),
        ChangeNotifierProvider(create: (_) => RequisitosProvider()),
        ChangeNotifierProvider(create: (_) => TecnologiasProvider()),
        ChangeNotifierProvider(create: (_) => TestesProvider()),
        ChangeNotifierProvider(create: (_) => TreinamentosProvider()),
      ],
      child: MaterialApp(
        title: 'Fábrica de Software',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/usuarios': (context) => const UsuariosScreen(),
          '/clientes': (context) => const ClientesScreen(),
          '/projetos': (context) => const ProjetosScreen(),
          '/contribuidores': (context) => const ContribuidoresScreen(),
          '/recursos': (context) => const RecursosScreen(),
          '/requisitos': (context) => const RequisitosScreen(),
          '/tecnologias': (context) => const TecnologiasScreen(),
          '/testes': (context) => const TestesScreen(),
          '/treinamentos': (context) => const TreinamentosScreen(),
        },
      ),
    );
  }
}
