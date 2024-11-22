import 'package:app_gp9/autenticacao.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget{

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  late Autenticar autenticador;

  @override
  void initState() {
    super.initState();
    initAutenticar();
  }

  Future<void> initAutenticar() async{
    autenticador = await Autenticar.init();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Column(
                  children: [
                    SizedBox(height: 120,),
                    Text("Seja Bem-Vindo",
                      style: TextStyle(
                        color:Color(0xFF001800), 
                        fontSize: 40,
                        fontFamily: "Megrim",
                        fontWeight: FontWeight.w900
                        ),
                      ),
                    SizedBox(height: 10,),
                    Text("Efetue seu login",
                      style: TextStyle(
                        color: Color(0xFF8EA4A4),
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                        ),
                      ),
                    SizedBox(height: 75,),
                  ],
                ),
              ),
              
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    ),
                  
                ),
              ),
              const SizedBox(height: 15,),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: () async {
                    //To-do
                    autenticador.logar(_emailController.text, _senhaController.text);

                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF628b27)), 
                    fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                    ), 
                  child: const Text("Entrar",
                          style: 
                            TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              ),
                          )
                  ),
                  
                  const SizedBox(height: 10,),
                  
                  FilledButton(onPressed: (){
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registro(autenticador: autenticador)));
                  
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF628b27)),
                    fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                    ), 
                  child: const Text("Cadastrar",
                          style: 
                            TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              ),
                          )
                  ),
                ],
              ),
              
              /*
              const SizedBox(height: 10,),
              const Text("Esqueceu a senha?"),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){}, child: const Text("Clique aqui",style: TextStyle(color: Color.fromRGBO(54, 9, 234, 1)),),)*/
              
            ],
          )
        
        ),
      );
     
    
  }
}

class Registro extends StatefulWidget{

  
  const Registro({super.key, required this.autenticador});
  final Autenticar autenticador;

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _senhaConfController = TextEditingController();

  void registrar(){
    //To-do
    if (_senhaController.text != _senhaConfController.text){
      throw Exception("As senhas estão diferentes");
    }
    widget.autenticador.registrar(
      _emailController.text, 
      _nomeController.text,
      _senhaController.text
      );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    Text("Cadastro",
                      style: TextStyle(
                        fontSize: 40, 
                        fontFamily: "Megrim",
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF001800)),),
                    SizedBox(height: 5,),
                    Text("Efetue seu cadastro",
                      style: TextStyle(
                        color: Color(0xFF8EA4A4), 
                        fontSize: 20),),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
              
              
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001800),
                      ),
                    ),
                  
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 320,
                child: TextField(
                  obscureText: false,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001800),
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 320,
                child: TextField(
                  obscureText: true,
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Criar Senha',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001800),
                      ),
                    ),
                  
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 320,
                child: TextField(
                  obscureText: true,
                  controller: _senhaConfController,
                  decoration: const InputDecoration(
                    labelText: 'Confimar senha',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001800),
                      ),
                    ),
                  
                ),
              ),
              
              const SizedBox(height: 55,),

              FilledButton(onPressed: registrar,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF628b27)),
                  fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                  ), 
                child: const Text("Cadastrar",
                          style: 
                            TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              ),
                        )
                ),
              const SizedBox(height: 10,),
              FilledButton(onPressed: (){
                Navigator.pop(context);
              },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF001800)),
                  fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                  ), 
                child: const Text("Voltar",
                          style: 
                            TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              ),
                        )
                ),
              
            
              
            ],
          )
        
        ),
      );
     
    
  }
}