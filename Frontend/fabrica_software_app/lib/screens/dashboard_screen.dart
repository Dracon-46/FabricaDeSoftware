import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'components/drawer_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'Usuários',
            icon: Icons.people,
            onTap: () => Navigator.of(context).pushNamed('/usuarios'),
            color: Colors.blue,
          ),
          _DashboardCard(
            title: 'Clientes',
            icon: Icons.business,
            onTap: () => Navigator.of(context).pushNamed('/clientes'),
            color: Colors.green,
          ),
          _DashboardCard(
            title: 'Projetos',
            icon: Icons.folder_special,
            onTap: () => Navigator.of(context).pushNamed('/projetos'),
            color: Colors.orange,
          ),
          _DashboardCard(
            title: 'Contribuidores',
            icon: Icons.person_outline,
            onTap: () => Navigator.of(context).pushNamed('/contribuidores'),
            color: Colors.purple,
          ),
          _DashboardCard(
            title: 'Recursos',
            icon: Icons.emoji_objects,
            onTap: () => Navigator.of(context).pushNamed('/recursos'),
            color: Colors.red,
          ),
          _DashboardCard(
            title: 'Requisitos',
            icon: Icons.list_alt,
            onTap: () => Navigator.of(context).pushNamed('/requisitos'),
            color: Colors.teal,
          ),
          _DashboardCard(
            title: 'Tecnologias',
            icon: Icons.computer,
            onTap: () => Navigator.of(context).pushNamed('/tecnologias'),
            color: Colors.indigo,
          ),
          _DashboardCard(
            title: 'Testes',
            icon: Icons.science,
            onTap: () => Navigator.of(context).pushNamed('/testes'),
            color: Colors.amber,
          ),
          _DashboardCard(
            title: 'Treinamentos',
            icon: Icons.school,
            onTap: () => Navigator.of(context).pushNamed('/treinamentos'),
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}