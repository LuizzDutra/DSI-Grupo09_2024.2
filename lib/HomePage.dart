import 'package:app_gp9/autenticacao.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget{

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                    Text("Seja Bem-Vindo",style: TextStyle(fontSize: 50),),
                    SizedBox(height: 10,),
                    Text("Efetue seu login",style: TextStyle(color: Color.fromARGB(142, 164, 164, 1)),),
                    SizedBox(height: 100,),
                  ],
                ),
              ),
              
              
              const SizedBox(
                width: 700,
                child: TextField(
                  decoration: 
                  InputDecoration(
                    labelText: 'E-mail ou Usuário',
                    border: OutlineInputBorder(),
                    ),
                  
                ),
              ),
              const SizedBox(height: 10,),
              const SizedBox(
                width: 700,
                child: TextField(
                  obscureText: true,
                  decoration: 
                  InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),

                    ),
                  
                ),
              ),
              const SizedBox(height: 15,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: (){},style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(66, 154,152, 1))), child: const Text("Acessar")),
                  const SizedBox(width: 15,),
                  FilledButton(onPressed: (){
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Registro()));
                  
                  },style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(66, 154,152, 1))), child: const Text("Cadastro")),
                ],
              ),
              
              const SizedBox(height: 10,),
              const Text("Esqueceu a senha?"),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){}, child: const Text("Clique aqui",style: TextStyle(color: Color.fromRGBO(54, 9, 234, 1)),),)
              
            ],
          )
        
        ),
      );
     
    
  }
}

class Registro extends StatefulWidget{

  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
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
                    Text("Cadastro",style: TextStyle(fontSize: 50, color: Color.fromARGB(92, 24, 190, 132)),),
                    SizedBox(height: 5,),
                    Text("Efetue seu cadastro",style: TextStyle(color: Color.fromARGB(142, 164, 164, 1), fontSize: 25),),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
              
              
              const SizedBox(
                width: 700,
                child: TextField(
                  decoration: 
                  InputDecoration(
                    labelText: 'Usuário',
                    //border: OutlineInputBorder(),
                    ),
                  
                ),
              ),
              const SizedBox(height: 20,),
              const SizedBox(
                width: 700,
                child: TextField(
                  obscureText: true,
                  decoration: 
                  InputDecoration(
                    labelText: 'Senha',
                    //border: OutlineInputBorder(),

                    ),
                  
                ),
              ),
              const SizedBox(height: 20,),
              const SizedBox(
                width: 700,
                child: TextField(
                  obscureText: true,
                  decoration: 
                  InputDecoration(
                    labelText: 'Confimar senha',
                    //border: OutlineInputBorder(),

                    ),
                  
                ),
              ),
              
              const SizedBox(height: 20,),
              
              const SizedBox(
                width: 700,
                child: TextField(
                  obscureText: true,
                  decoration: 
                  InputDecoration(
                    labelText: 'E-mail',
                    //border: OutlineInputBorder(),

                    ),
                  
                ),
              ),
              
              const SizedBox(height: 55,),

              FilledButton(onPressed: (){},style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(66, 154,152, 1))), child: const Text("Cadastrar")),
              
            
              
            ],
          )
        
        ),
      );
     
    
  }
}