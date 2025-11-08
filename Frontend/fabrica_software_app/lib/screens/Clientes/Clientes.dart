import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:fabrica_software_app/Widgets/Nivel_icon/Nivel_icon.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';
import 'package:fabrica_software_app/screens/Clientes/components/ClienteRow.dart';
import 'package:fabrica_software_app/screens/Clientes/components/Cliente_modal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientesProvider>(context, listen: false).carregarClientes();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final clientesProvider = context.watch<ClientesProvider>();
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
                  //Filter place here
                  const SizedBox(height: 24),
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
                        if (clientesProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (clientesProvider.error != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text('Erro ao buscar clientes: ${clientesProvider.error}'),
                            ),
                          )
                        else if (clientesProvider.clientes == null || clientesProvider.clientes!.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Nenhum cliente encontrado.'),
                            ),
                          )
                        else
                          Column(
                            children: clientesProvider.clientes!.map((cliente) {
                              return ClienteRow(
                                razaoSocial: cliente.razaoSocial, 
                                CNPJ: cliente.cnpj,
                                setor:'${cliente.setor}' ,
                                contato: cliente.email,
                                onView: () => _abrirModalCliente(context, cliente, ClienteModalMode.view),
                                onEdit: () => _abrirModalCliente(context, cliente, ClienteModalMode.edit),
                                onDelete: () => _abrirModalCliente(context, cliente, ClienteModalMode.delete),
                              );
                            }).toList(),
                          ),

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

void _abrirModalCliente(BuildContext context, Cliente cliente, ClienteModalMode modo) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede de fechar clicando fora
    builder: (ctx) => ClienteModal(
      mode: modo,       // Passa o MODO
      cliente: cliente, // Passa o CLIENTE
    ),
  );
}





