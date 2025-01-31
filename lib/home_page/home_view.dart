import 'package:app_gp9/login_page.dart';
import 'package:app_gp9/perfil/perfil_view.dart';
import 'package:app_gp9/plano/planos_view_temp.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Map<String, dynamic> routes = {
    "planos" : MyPlaceholder(),
    "perfil" : PerfilView(),
    "login" : Login()
  };

  MaterialPageRoute getRoute(String name){
    return MaterialPageRoute(builder: (context) => routes[name]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFFFEFEE3),
      body: Container(alignment: Alignment.center,child: Text("Bem vindo!")),
      floatingActionButton: IconButton(onPressed: (){
        _key.currentState!.openDrawer();
      }, icon: Icon(Icons.menu)),
      drawer: Drawer(
        child: ListView(children: [
          const DrawerHeader(child: Text("Head")),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Perfil"),
            onTap: (){
              Navigator.push(context, getRoute("perfil"));
            }
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("Plano de Negócios"),
            onTap: (){
              Navigator.push(context, getRoute("planos"));
            }
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("SWOT"),
          ),
          ListTile(
            leading: Icon(Icons.no_accounts),
            title: Text("Deslogar"),
            onTap: (){
              Navigator.pushReplacement(context, getRoute("login"));
            }
          )
        ],),
      )
      );
  }
}