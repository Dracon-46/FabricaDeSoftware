import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalDeCriacao extends StatelessWidget {
final String titulo;
final IconData icon;
final String tabName;
final Widget body;
final Widget footer;
  const ModalDeCriacao({
    super.key,required this.titulo, required this.icon,required this.tabName, required this.body,required this.footer
  });
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      
      child: Container(
        width: double.infinity,

        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700), // Ajuste
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Column(
          children: [
            

            _buildHeader(context),
            const Divider(height: 1, color: Color.fromARGB(50, 158, 158, 158)), 

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0), 
                child: body,
              ),
            ),

            Container(
              child:Row(children:<Widget>[ Expanded(child:footer)]),
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(66, 150, 146, 146),     
                    blurRadius: 3,            
                    offset: Offset(0, -10),      
                  ),
                ],
              ),
            ),

            
          ],
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(child:FaIcon(icon,color: Colors.white,),padding: EdgeInsets.all(8),
              decoration:
                BoxDecoration(gradient: LinearGradient( colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,),
                  borderRadius: BorderRadius.circular(10)),
                  ) ,
        
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$titulo',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(onPressed: (){}, icon:FaIcon(FontAwesomeIcons.caretLeft)),
              Text('$tabName'),
              IconButton(onPressed: (){}, icon:FaIcon(FontAwesomeIcons.caretRight)),
              const SizedBox(width: 20),
              IconButton(
                iconSize: 15,
                color: Color.fromARGB(171, 179, 177, 177),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ], 
          ),
          const SizedBox(height: 16),
          // Barra de Progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progresso do formulário', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('${(40).toInt()}%', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  
}