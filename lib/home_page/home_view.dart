import 'package:app_gp9/home_page/chat_bubble.dart';
import 'package:app_gp9/home_page/home_controller.dart';
import 'package:app_gp9/login_page.dart';
import 'package:app_gp9/mapa/mapa_view.dart';
import 'package:app_gp9/perfil/perfil_view.dart';
import 'package:app_gp9/meta_financeira/view/metas_home_view.dart';

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
    "mapa" : const MapaView(),
    "metas" : const MetasHomeView(), 
  };

  MaterialPageRoute getRoute(String name){
    return MaterialPageRoute(builder: (context) => routes[name]!);
  }

  List<Widget> chatList = [
                          ChatBubble(
                            text:
                                'Olá! Em que posso ajudar você hoje?',
                                left: true
                          ),
                        ];

  TextEditingController textController = TextEditingController();
  String userName = "";

  @override
  void initState() {
    super.initState();
    HomeController.getUserName().then((value) => setState(() => userName = value));
  }


  void sendMessage(){
    setState(() => chatList.add(ChatBubble(text: textController.text)));
    chatList.add(FutureBuilder(
      future: HomeController.sendMessage(textController.text),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData){
          return ChatBubble(text:snapshot.data!, left:true);
        }else if(snapshot.hasError){
          return ChatBubble(text: snapshot.error.toString(), left:true);
        }else{
          return ChatBubble(text: "**...**", left:true);
        }
      },
    ));
    textController.text = "";
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
        backgroundColor: customColors[6],
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 17, right: 17, top: 15, bottom: MediaQuery.sizeOf(context).height*0.1),
                    reverse: true,
                    child: Column(
                        children: chatList
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height*0.11,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(right: 4, left: 4, top: 0, bottom: 30),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(color: Color(0xFFE8EBF0), borderRadius: BorderRadius.circular(10)),
                    child: Wrap(
                      spacing: 30,
                      direction: Axis.horizontal,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width*0.75, minHeight: MediaQuery.sizeOf(context).height*0.055),
                          child: TextField(
                            controller: textController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                  hintText: "Tire suas dúvidas.",
                                  hintStyle: TextStyle(color: Color(0x77000000)),
                                  border: InputBorder.none
                                  ),
                            onEditingComplete: sendMessage
                            ),
                        ),
                        IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
                      ],
                    ),
                  )),
            ),
          ],
        ),
      appBar: AppBar(
        backgroundColor: customColors[7],
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: () => _key.currentState!.openDrawer(), icon: Icon(Icons.menu), color: Colors.white),
        iconTheme: IconThemeData(size: 35),
        toolbarHeight: MediaQuery.sizeOf(context).height*0.1,
        title: Wrap(
          spacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/Logo.png")),
            Text("Perene", style: TextStyle(fontSize: 30),)
        ],),
      ),
      drawer: Drawer(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(userName, textAlign: TextAlign.left, 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
          ),
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
            leading: Icon(Icons.monetization_on, color: const Color.fromARGB(255, 74, 74, 74)),
            title: Text("Metas Financeiras"),
            onTap: () {Navigator.push(context, getRoute("metas"));
              },
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