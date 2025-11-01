import 'package:fabrica_software_app/providers/menu_provider.dart';
import 'package:fabrica_software_app/screens/Api_teste/Teste.dart';
import 'package:fabrica_software_app/screens/Cadastro/Cadastro_screen.dart';
import 'package:fabrica_software_app/screens/Account/Account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/usuarios_provider.dart';
import 'providers/projetos_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/Api_teste/api_test_screen.dart';
import 'screens/Login/login_screen.dart';
import 'screens/Gerenciar_Projetos/Gerenciar_projetos.dart';

void main() {
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_){return MenuProvider();})
      ],  
      child: MyApp(),
    )
  );
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
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/':(context){return const Loginscreen();},
          '/Cadastro':(context){return const CadastroScreen();},
          '/ApiTest':(context){return const ApiTestScreen();},
          '/Gerenciar_Projetos':(context){return const GerenciarProjetos();},
          '/Teste':(context){return const Teste();},
          '/Account':(context){return const Account();}
        },
        title: 'Fábrica de Software',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
      ),
    );
  }
}
