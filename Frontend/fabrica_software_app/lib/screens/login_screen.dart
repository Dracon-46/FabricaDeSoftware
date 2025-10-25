import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
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
                                  'Entre na sua conta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
                                ),
                                
                                const SizedBox(height: 32),
                                
                                Text(
                                  'Email*',
                                  style: TextStyle(fontWeight: FontWeight.bold), 
                                ),
                                const SizedBox(height: 8), 

                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'usuario@tegra.com.br',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                Text(
                                  'Senha*',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),

                                TextField(
                                  obscureText: true, 
                                  decoration: InputDecoration(
                                    hintText: '********',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                Align( 
                                  alignment: Alignment.centerRight,
                                  child: MouseRegion( 
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () { print('Esqueci a senha'); },
                                      child: Text(
                                        'Esqueci a senha',
                                        style: TextStyle(color: Color.fromARGB(255, 83, 10, 255)), 
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                ElevatedButton(
                                  onPressed: (){ print('Clicou em Entrar'); }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 38, 57, 177),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder( 
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, 
                                  children: <Widget>[
                                    Text('Não tem uma conta? '),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child:GestureDetector(
                                        onTap: () { print('Clicou em Cadastrar-se'); },
                                        child:Text(
                                          'Cadastrar-se',
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
}