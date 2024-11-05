import 'package:app_gp9/backend.dart';
import 'package:flutter/material.dart';

class Frontend extends StatelessWidget {

  const Frontend({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
          appBar: 
            AppBar(title: const Row(
              children: [
                SizedBox(width: 83,),
                Text('DEMO DSI'),
              ],
            ),
                  backgroundColor: Colors.greenAccent,
                  
              ),
          drawer: 
            const Drawer(
              child: Center(child: Text("Teste"),),
            ),
           body: Center(child: ElevatedButton(onPressed: ()
           {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Aplicativo',)));
           }, child: const Text("Iniciar Monitoramento")),),
       );
  }
}