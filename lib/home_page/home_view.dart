import 'package:app_gp9/home_page/home_controller.dart';
import 'package:app_gp9/login_page.dart';
import 'package:app_gp9/mapa/mapa_view.dart';
import 'package:app_gp9/perfil/perfil_view.dart';

import 'package:app_gp9/swot/views/home_view.dart';
import 'package:app_gp9/plano/view/planos_view_temp.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/custom_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Map<String, dynamic> routes = {

    "planos" : const MyPlaceholder(),
    "swots" : const HomeView(),
    "perfil" : const PerfilView(),
    "login" : const Login(),
    "mapa" : const MapaView()
  };

  MaterialPageRoute getRoute(String name){
    return MaterialPageRoute(builder: (context) => routes[name]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: customColors[6],
      body: Container(alignment: Alignment.center,child: Text("Bem vindo!")),
      appBar: AppBar(
        backgroundColor: customColors[6],
        leading: IconButton(onPressed: () => _key.currentState!.openDrawer(), icon: Icon(Icons.menu)),
        iconTheme: IconThemeData(size: 35),
      ),
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
            onTap : (){
              Navigator.push(context, getRoute('swots'));
            }
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("Outras empresas"),
            onTap: () => Navigator.push(context, getRoute("mapa"))
          ),
          ListTile(
            leading: Icon(Icons.no_accounts),
            title: Text("Deslogar"),
            onTap: (){
              HomeController.signOut();
              Navigator.pushReplacement(context, getRoute("login"));
            }
          )
        ],),
      )
      );
  }
}