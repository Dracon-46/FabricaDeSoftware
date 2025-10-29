import 'package:flutter/material.dart';

// --- Ponto de Entrada da Aplicação ---
void main() {
  runApp(const ProjectDashboardApp());
}

class ProjectDashboardApp extends StatelessWidget {
  const ProjectDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Projetos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define um tom de azul primário próximo ao da imagem
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Azul do botão "Novo Projeto"
          primary: const Color(0xFF3B82F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Fundo levemente cinza
        fontFamily: 'Roboto', // Uma fonte limpa e moderna
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937)),
          titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

// --- Tela Principal do Dashboard ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Controla o item selecionado no menu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. Menu Lateral
          _buildSideMenu(),

          // 2. Conteúdo Principal (expande para preencher o espaço)
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  // Widget para o Menu Lateral
  Widget _buildSideMenu() {
    return Container(
      width: 250, // Largura do menu
      color: const Color(0xFF003366), // Azul escuro da "Fabrica Software"
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              "Fabrica Software",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Itens do Menu
          _buildMenuItem(
              icon: Icons.folder_open,
              title: "Projetos",
              index: 0,
              isSelected: _selectedIndex == 0),
          _buildMenuItem(
              icon: Icons.people_outline,
              title: "Equipe",
              index: 1,
              isSelected: _selectedIndex == 1),
          _buildMenuItem(
              icon: Icons.bar_chart_outlined,
              title: "Relatórios",
              index: 2,
              isSelected: _selectedIndex == 2),
          _buildMenuItem(
              icon: Icons.manage_accounts_outlined,
              title: "Gestão de Usuários",
              index: 3,
              isSelected: _selectedIndex == 3),
          _buildMenuItem(
              icon: Icons.person_search_outlined,
              title: "Gestão de Clientes",
              index: 4,
              isSelected: _selectedIndex == 4),

          // Espaçador para empurrar o item de rodapé para baixo
          const Spacer(),

          // Item de Rodapé (Master)
          _buildMenuItem(
              icon: Icons.shield_outlined,
              title: "MASTER",
              index: 99,
              isSelected: false,
              isFooter: true),
        ],
      ),
    );
  }

  // Widget auxiliar para criar um item do menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    bool isFooter = false,
  }) {
    final color = isSelected ? Colors.white : Colors.blue[200];
    final bgColor =
        isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (!isFooter) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        trailing: isFooter ? Icon(Icons.logout, color: color, size: 16) : null,
      ),
    );
  }

  // Widget para o Conteúdo Principal
  Widget _buildMainContent() {
    // Para telas muito grandes, limita a largura do conteúdo central
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabeçalho (Título e Botão)
              _buildHeader(),
              const SizedBox(height: 24),

              // 2. Filtros de Pesquisa
              _buildFilterSection(),
              const SizedBox(height: 24),

              // 3. Título da Lista de Projetos
              Text(
                "Projetos (12)",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              // 4. Grade de Projetos
              _buildProjectGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Cabeçalho: Título e Botão
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gestão de Projetos",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              "Gerencie seus projetos e recursos de forma eficiente",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
          label:
              const Text("Novo Projeto", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE50914), // Vermelho do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  // Seção de Filtros
  Widget _buildFilterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filtros de Pesquisa",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Limpar Filtros",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // O 'Wrap' torna os filtros responsivos. Em telas menores,
            // eles quebrarão para a próxima linha.
            Wrap(
              spacing: 16.0, // Espaço horizontal entre os filtros
              runSpacing: 16.0, // Espaço vertical entre as linhas de filtros
              children: [
                _buildFilterTextField("Nome do Projeto"),
                _buildFilterDropdown("Todos os tipos"),
                _buildFilterTextField("Nome do cliente..."),
                _buildFilterDropdown("Todos os status"),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para campo de texto do filtro
  Widget _buildFilterTextField(String hintText) {
    return SizedBox(
      width: 250, // Largura fixa para cada filtro
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  // Widget auxiliar para dropdown do filtro
  Widget _buildFilterDropdown(String hintText) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hintText, style: const TextStyle(color: Color(0xFF6B7280))),
          items: const [], // Sem itens, pois é apenas visual
          onChanged: (value) {},
        ),
      ),
    );
  }

  // Grade de Projetos
  Widget _buildProjectGrid() {
    // Usando 'Wrap' novamente para uma grade responsiva
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: mockProjects.map((project) {
        // Cada cartão deve ter uma largura flexível, mas limitada
        return SizedBox(
          width: 400, // Largura de cada cartão
          child: ProjectCard(project: project),
        );
      }).toList(),
    );
  }
}

// --- DADOS MOCKADOS E MODELO ---

// Modelo de dados simples para um projeto
class Project {
  final String title;
  final String client;
  final String description;
  final String status;
  final String tag;
  final IconData icon;

  Project({
    required this.title,
    required this.client,
    required this.description,
    required this.status,
    required this.tag,
    required this.icon,
  });
}

// Lista de dados fictícios para preencher a UI
final List<Project> mockProjects = [
  Project(
    title: "E-commerce Platform",
    client: "Cliente 1",
    description: "Desenvolvimento de plataforma completa de e-commerce com integração...",
    status: "Em processo",
    tag: "Web",
    icon: Icons.shopping_cart_outlined,
  ),
  Project(
    title: "Mobile Banking App",
    client: "Cliente 2",
    description: "Aplicativo móvel para operações bancárias com biometria e notificações...",
    status: "Concluído",
    tag: "Mobile",
    icon: Icons.phone_android_outlined,
  ),
  Project(
    title: "CRM API Integration",
    client: "Cliente 3",
    description: "Integração de API REST para sincronização de dados entre sistemas CRM...",
    status: "Pausado",
    tag: "API",
    icon: Icons.sync_alt_outlined,
  ),
];

// --- WIDGET DO CARTÃO DE PROJETO ---

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  // Define a cor do "chip" de status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Em processo":
        return Colors.orange.shade100;
      case "Concluído":
        return Colors.green.shade100;
      case "Pausado":
        return Colors.grey.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Em processo":
        return Colors.orange.shade800;
      case "Concluído":
        return Colors.green.shade800;
      case "Pausado":
        return Colors.grey.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha Superior: Ícone e Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ícone
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(project.icon, color: Colors.blue.shade600),
                ),
                // Chip de Status
                Chip(
                  label: Text(
                    project.status,
                    style: TextStyle(
                      color: _getStatusTextColor(project.status),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getStatusColor(project.status),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Textos: Título e Cliente
            Text(project.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(project.client,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 8),

            // Descrição
            Text(
              project.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Linha Inferior: Avatares e Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatares (simulados)
                _buildAvatarStack(),
                // Tag
                Chip(
                  label: Text(
                    project.tag,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  side: BorderSide.none,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para a pilha de avatares
  Widget _buildAvatarStack() {
    // Simula os 3 avatares da imagem
    return Stack(
      children: [
        _buildAvatar(Colors.blue, 40),
        _buildAvatar(Colors.red, 20),
        _buildAvatar(Colors.green, 0),
      ],
    );
  }

  Widget _buildAvatar(Color color, double left) {
    return Padding(
      padding: EdgeInsets.only(left: left),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        child: Text(
          "A", // Placeholder
          style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 249, 248, 252)),
        ),
      ),
    );
  }
}