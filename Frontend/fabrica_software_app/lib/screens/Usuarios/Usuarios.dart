import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:fabrica_software_app/Widgets/Nivel_icon/Nivel_icon.dart';
import 'package:fabrica_software_app/screens/Usuarios/components/UserRow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Usuarios extends StatelessWidget {
  const Usuarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BarraLateral(),
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomAppBar(
        title: 'Gestão de Clientes',
        listaActions: [
          ElevatedButton(onPressed: () {}, child: Text('botão')),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 34),
                  
                  // --- INÍCIO: Conteúdo de _buildFilterCard ---
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const FaIcon(FontAwesomeIcons.filter, size: 35),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              children: [
                                // --- INÍCIO: Conteúdo de _buildFilterTextField("Razão Social") ---
                                Container(
                                  width: 200,
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Razão Social",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey[300]!),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                  ),
                                ),
                                // --- FIM: Conteúdo de _buildFilterTextField ---
                                // --- INÍCIO: Conteúdo de _buildFilterTextField("CNPJ") ---
                                Container(
                                  width: 200,
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "CNPJ",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey[300]!),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                  ),
                                ),
                                // --- FIM: Conteúdo de _buildFilterTextField ---
                                // --- INÍCIO: Conteúdo de _buildFilterTextField("Contato") ---
                                Container(
                                  width: 200,
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Contato",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey[300]!),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                  ),
                                ),
                                // --- FIM: Conteúdo de _buildFilterTextField ---
                                // --- INÍCIO: Conteúdo de _buildFilterTextField("Setor") ---
                                Container(
                                  width: 200,
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Setor",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey[300]!),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                  ),
                                ),
                                // --- FIM: Conteúdo de _buildFilterTextField ---
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Filtrar'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 37, 99, 235), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Limpar'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 0, 0), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          )
                        ],
                      ),
                    ),
                  ),
                  // --- FIM: Conteúdo de _buildFilterCard ---

                  const SizedBox(height: 24),

                  // --- INÍCIO: Conteúdo de _buildClientListCard ---
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lista de Clientes',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '24 clientes encontrados',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[50],
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          // --- INÍCIO: Conteúdo de _buildClientRow (Header) ---
                          child: Container(
                            decoration: BoxDecoration(
                              border: null, // 'isHeader' é true
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(''), // 'avatar'
                                      // 'if (!isHeader)' é falso, então não há SizedBox
                                      Expanded(child: Text('Razão Social', style: TextStyle(fontWeight: FontWeight.bold))), // 'nome'
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text('CNPJ', style: TextStyle(fontWeight: FontWeight.bold))), // 'cnpj'
                                Expanded(flex: 1, child: Text('Setor', style: TextStyle(fontWeight: FontWeight.bold))), // 'setor'
                                Expanded(flex: 2, child: Text('Contato', style: TextStyle(fontWeight: FontWeight.bold))), // 'contato'
                                Expanded(flex: 1, child: Text('Projeto(s)', style: TextStyle(fontWeight: FontWeight.bold))), // 'projeto'
                                Expanded(flex: 1, child: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))), // 'acoes'
                              ],
                            ),
                          ),
                          // --- FIM: Conteúdo de _buildClientRow (Header) ---
                        ),
                        
                        // --- INÍCIO: Conteúdo de _buildClientRow (Data) ---
                        Userrow()

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}