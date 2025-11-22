import 'package:fabrica_software_app/Widgets/Modal_de_criacao/components/Modal_step.dart';
import 'package:fabrica_software_app/providers/modal_criacao_projeto_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LevantamentosRequisitosStep extends ModalStep{
@override
  String get title => 'Levantamento de requisitos com IA';

    @override
  String get tabName => 'Levantamento de requisitos';

  @override
  IconData get icon => FontAwesomeIcons.robot;

  @override
  List<Color> get cores => <Color>[Colors.amberAccent,Colors.blueAccent];

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Conteúdo da Etapa 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(decoration: InputDecoration(labelText: 'Nome do Projeto')),
        TextField(decoration: InputDecoration(labelText: 'Descrição')),
        
      ],  
    );
  }

  @override
  Widget buildFooter(BuildContext context) {
    // O Footer agora pode ter lógica específica desta etapa
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            // Chama o provider para avançar
            context.read<ModalCriacaoProjetoProvider>().nextIndex();
          },
          child: const Text('Próximo'),
        ),
      ],
    );
  }
}

