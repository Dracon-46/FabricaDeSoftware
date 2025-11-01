import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GerenciarProjetos extends StatefulWidget {
  const GerenciarProjetos({super.key});

  @override
  State<GerenciarProjetos> createState() => _GerenciarProjetosState();
}

class _GerenciarProjetosState extends State<GerenciarProjetos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Gestão de Projetos'),
      drawer: BarraLateral(iconUser: FontAwesomeIcons.dragon, userName: 'Master'),
    );
  }
}