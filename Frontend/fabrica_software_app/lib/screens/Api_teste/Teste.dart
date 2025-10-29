import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart'; // 1. Você importou seu widget customizado
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Teste extends StatelessWidget {
  const Teste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Você usou a propriedade 'drawer:' do Scaffold
      drawer: BarraLateral(iconUser:FontAwesomeIcons.dragon ,userName: 'Usuario',), // 3. E passou uma instância do seu widget

      // 4. (Próximo Passo) Adicione uma AppBar para ter o botão de abrir
      appBar: AppBar(
        title: Text('Minha Tela'),
        // Não precisa adicionar o botão hambúrguer manualmente aqui,
        // o Scaffold faz isso se houver um 'drawer'.
      ),

      // 5. Adicione o conteúdo principal da tela
      body: Center(
        child: Text('Conteúdo da tela Teste'),
      ),
    );
  }
}