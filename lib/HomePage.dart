import 'package:flutter/material.dart';
import 'package:app_gp9/database_usuarios.dart';
import 'package:app_gp9/autenticacao.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String dbQuery = '';

  String usuario = '';

  Future<dynamic> pegarQuery() async{
    var query = await UserDatabase().pegarTabelaUsuario();
    setState((){
      dbQuery = query.toString();
    });
  }

  //função demo apenas para chamada do banco de dados
  Future<void> registrarUsuario() async{
    try{
      await Autenticar.registrar("Beltrano@e.com", "Beltrano", "0000");
    }on Exception catch(e){
      print(e);
    }
    pegarQuery();
  }
  
  Future<void> logarAdmin() async{
    await Autenticar.logar("luizzidutra@gmail.com", "admin000");
    setState(() {
      usuario = Autenticar.usuarioLogado;
    });
  }

  @override
  void initState() {
    super.initState();
    registrarUsuario();
    pegarQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          style: const TextStyle(
            fontSize: 25,
          ),
          "O query foi: $dbQuery"),
        Text(
          style: const TextStyle(
            fontSize: 25,
          ),
          "Logado como: $usuario"),
        FloatingActionButton(onPressed: () => logarAdmin()),
      ],
    );
  }
}
