import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:fabrica_software_app/Widgets/Modal_de_criacao/Modal_de_criacao.dart';
import 'package:fabrica_software_app/providers/modal_criacao_projeto_provider.dart';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


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
      drawer: BarraLateral(),
      body:ElevatedButton(onPressed: (){abrirModalCriacao(context);}, child: Text('Abrir modal')),
    );
  }
}


void abrirModalCriacao(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => ModalCriacaoProjetoProvider(),
        child: ModalDeCriacao(),
      );
    },
  );
}