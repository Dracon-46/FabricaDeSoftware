import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:fabrica_software_app/Widgets/Modal_de_criacao/Modal_de_criacao.dart';
import 'package:fabrica_software_app/Widgets/Nivel_icon/Nivel_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Teste extends StatelessWidget {
  const Teste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BarraLateral(),
      
      appBar: CustomAppBar(title:'Meu titulo'),
      
      body: Center(
        child: Column(
          // Adicionei MainAxisAlignment.center para centralizar a coluna
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[
            Text('Conteúdo da tela Teste'),
            
            // --- O BOTÃO FOI MODIFICADO AQUI ---
            ElevatedButton(
              child: Text('Abrir Modal (Silencioso)'), // Mudei o texto do botão
              onPressed: () {
                
                // 1. Trocamos showDialog por showGeneralDialog
                showGeneralDialog(
                  context: context,
                  
                  // 2. Tornamos a barreira (scrim) padrão INVISÍVEL
                  //    É ela que causa o som do sistema.
                  barrierColor: Colors.transparent, 
                  
                  // 3. O modal AINDA não pode ser fechado clicando fora
                  barrierDismissible: false, 
                  barrierLabel: 'Modal',
                  
                  // 4. Duração da animação
                  transitionDuration: const Duration(milliseconds: 300),

                  // 5. O pageBuilder constrói TUDO (nossa barreira + o modal)
                  pageBuilder: (context, anim1, anim2) {
                    
                    // 6. Usamos um Stack para empilhar
                    return Stack(
                      children: [
                        
                        // --- CAMADA 1: Nossa Barreira "Silenciosa" ---
                        GestureDetector(
                          // 7. A MÁGICA: "Come" o clique sem fazer barulho
                          onTap: () {}, 
                          child: Container(
                            // 8. O scrim (fundo escuro) customizado
                            color: Colors.black.withOpacity(0.6), 
                          ),
                        ),

                        // --- CAMADA 2: O Seu Modal ---
                        //    (O Center posiciona o seu modal no meio)
                        Center(
                          // 9. Retornamos o SEU widget de modal aqui
                          child: const ModalDeCriacao(
                            body: Text('Testando'),
                            footer: Text('Testando'),
                            icon: FontAwesomeIcons.robot,
                            titulo: 'Levantamento',
                            tabName: 'Requisitos',
                          ),
                        ),
                      ],
                    );
                  },

                  // 10. (Opcional) Animação de Fade (Esmaecer)
                  transitionBuilder: (context, anim1, anim2, child) {
                    return FadeTransition(
                      opacity: anim1,
                      child: child,
                    );
                  },
                );
              },
            )
            // --- FIM DA MODIFICAÇÃO ---
          ],
        ),
      ),
    );
  }
}