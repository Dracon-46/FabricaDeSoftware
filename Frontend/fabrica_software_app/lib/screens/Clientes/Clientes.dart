import 'package:fabrica_software_app/Widgets/App_bar/App_bar.dart';
import 'package:fabrica_software_app/Widgets/Barra_lateral/Barra_Lateral.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';
import 'package:fabrica_software_app/providers/endereco_provider.dart';
// 1. IMPORTAÇÃO DO ENDERECOS PROVIDER
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

    // 2. REGISTA O PROVIDER DE ENDEREÇOS
    return ChangeNotifierProvider(
      create: (_) => EnderecosProvider(),
      
      // 3. USA UM BUILDER PARA OBTER UM CONTEXTO VÁLIDO
      child: Builder(
        builder: (scaffoldContext) {
          // Este 'scaffoldContext' pode ver o EnderecosProvider

          // 4. LÊ A INSTÂNCIA DO PROVIDER AQUI
          final enderecosProvider = scaffoldContext.read<EnderecosProvider>();

          return Scaffold(
            drawer: BarraLateral(),
            backgroundColor: const Color(0xFFF1F5F9),
            appBar: CustomAppBar(
              title: 'Gestão de Clientes',
              listaActions: [
                ElevatedButton.icon(
                  // 5. PASSA O CONTEXTO E A INSTÂNCIA DO PROVIDER
                  onPressed: () => _abrirModalCriarCliente(scaffoldContext, enderecosProvider), 
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Novo Cliente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Cor rosa/magenta
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
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
                                    border: null, 
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child:
                                            Expanded(child: Text('Razão Social', style: TextStyle(fontWeight: FontWeight.bold))), // 'nome'
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
                                      // 6. PASSA O CONTEXTO E A INSTÂNCIA DO PROVIDER
                                      onView: () => _abrirModalCliente(scaffoldContext, cliente, ClienteModalMode.view, enderecosProvider),
                                      onEdit: () => _abrirModalCliente(scaffoldContext, cliente, ClienteModalMode.edit, enderecosProvider),
                                      onDelete: () => _abrirModalCliente(scaffoldContext, cliente, ClienteModalMode.delete, enderecosProvider),
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
      ),
    );
  }
}

// 7. ATUALIZA A FUNÇÃO PARA RECEBER O PROVIDER
void _abrirModalCliente(BuildContext context, Cliente cliente, ClienteModalMode modo, EnderecosProvider provider) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false, // Mantém isto
    builder: (ctx) => ClienteModal(
      mode: modo,
      cliente: cliente,
      enderecosProvider: provider, // 8. PASSA O PROVIDER PARA O MODAL
    ),
  );
}

// 7. ATUALIZA A FUNÇÃO PARA RECEBER O PROVIDER
void _abrirModalCriarCliente(BuildContext context, EnderecosProvider provider) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    useRootNavigator: false, // Mantém isto
    builder: (ctx) => ClienteModal( // Remove o 'const'
      mode: ClienteModalMode.create,
      enderecosProvider: provider, // 8. PASSA O PROVIDER PARA O MODAL
    ),
  );
}