import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/usuarios_service.dart';
import '../providers/auth_provider.dart';
import 'api_test_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 115, 231),

      body:
          Center( 
            child:
                Container( 
                  constraints: const BoxConstraints(maxWidth: 450),
                  margin: const EdgeInsets.all(16.0),
                  
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), 
                          blurRadius: 8.0,
                          spreadRadius: 1.0, 
                          offset: Offset(0, 2),
                          ),
                      ]
                  ),
                  
                  child:
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: 
                            Column( 
                              mainAxisSize: MainAxisSize.min, 
                              crossAxisAlignment: CrossAxisAlignment.stretch, 
                              
                              children: <Widget>[
                                Image.asset('assets/image/tegra_logo.png',width:35,height:35,),
                                
                                const SizedBox(height: 16), 
                                
                                Text(
                                  'Crie sua conta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
                                ),

                                 const SizedBox(height: 32),
                                
                                Text(
                                  'Nome completo*',
                                  style: TextStyle(fontWeight: FontWeight.bold), 
                                ),
                                const SizedBox(height: 8), 

                                TextField(
                                  controller: _nomeController,
                                  decoration: InputDecoration(
                                    hintText: 'Digite seu nome completo',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                      
                                
                                Text(
                                  'Telefone*',
                                  style: TextStyle(fontWeight: FontWeight.bold), 
                                ),
                                const SizedBox(height: 8), 

                                TextField(
                                  controller: _telefoneController,
                                  decoration: InputDecoration(
                                    hintText: '(15) 99999-9999',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                Text(
                                  'Email*',
                                  style: TextStyle(fontWeight: FontWeight.bold), 
                                ),
                                const SizedBox(height: 8), 

                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'seu@email.com',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                Text(
                                  'Senha*',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),

                                TextField(
                                  controller: _senhaController,
                                  obscureText: true, 
                                  decoration: InputDecoration(
                                    hintText: '********',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Text(
                                  'Confirme a senha*',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),

                                TextField(
                                  controller: _confirmSenhaController,
                                  obscureText: true, 
                                  decoration: InputDecoration(
                                    hintText: '********',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24,),
                                

                                ElevatedButton(
                                  onPressed: _isLoading ? null : () async {
                                    // Validações simples
                                    final nome = _nomeController.text.trim();
                                    final telefone = _telefoneController.text.trim();
                                    final email = _emailController.text.trim();
                                    final senha = _senhaController.text;
                                    final confirm = _confirmSenhaController.text;

                                    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Preencha nome, email e senha')),
                                      );
                                      return;
                                    }

                                    if (senha != confirm) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('As senhas não coincidem')),
                                      );
                                      return;
                                    }

                                    setState(() => _isLoading = true);

                                    try {
                                      final data = {
                                        'nome': nome,
                                        'email': email,
                                        'senha': senha,
                                        'nivel': 'colaborador', // padrão
                                        'telefone': telefone,
                                      };

                                      final usuario = await UsuariosService.instance.criarUsuario(data);

                                      // Tentar login automático após cadastro
                                      final auth = context.read<AuthProvider>();
                                      final success = await auth.login(email, senha);

                                      if (!mounted) return;

                                      if (success) {
                                        Navigator.pushReplacementNamed(context,'/ApiTest');
                                          
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Usuário criado: ${usuario.nome}. Faça login.')),
                                        );
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Erro ao criar usuário: ${e.toString()}')),
                                        );
                                      }
                                    } finally {
                                      if (mounted) setState(() => _isLoading = false);
                                    }
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 38, 57, 177),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder( 
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Cadastrar-se', style: TextStyle(fontSize: 18)),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, 
                                  children: <Widget>[
                                    Text('já tem uma conta? '),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child:GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child:Text(
                                          'Fazer login',
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 83, 10, 255), 
                                            fontWeight: FontWeight.bold,
                                          )
                                        )
                                      ), 
                                    ), 
                                  ]
                                )
                              ],
                            ), 
                      ),
                ),
          ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    super.dispose();
  }
}