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

  Future<dynamic> pegarQuery() async{
    var query = await UserDatabase().pegarTabelaUsuario();
    setState((){
      dbQuery = query.toString();
    });
  }

  //função demo apenas para chamada do banco de dados
  Future<void> registrarUsuario() async{
    Autenticar autenticar = Autenticar();
    try{
      await autenticar.registrar("Beltrano@e.com", "Beltrano1", "1234");
    }on Exception catch(e){
      print(e);
    }
    pegarQuery();
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
        Text("O query foi: $dbQuery"),
      ],
    );
  }
}
