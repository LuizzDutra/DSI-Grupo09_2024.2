import 'dart:ffi';

import 'package:app_gp9/plano_negocios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPlaceholder extends StatefulWidget {
  const MyPlaceholder({super.key});

  @override
  State<MyPlaceholder> createState() => _MyPlaceholderState();
}

class _MyPlaceholderState extends State<MyPlaceholder> {
  late Future<List<PlanoNegocios>> planos;

  static teste() async {
    
    PlanoNegocios teste = PlanoNegocios(
      "Clientes com alto poder aquisitivo",
      "Produto de luxo",
      "Vendas online e lojas físicas",
      "Parcerias com influenciadores",
      "Vendas de produtos",
      "Equipe de vendas e marketing",
      "Campanhas publicitárias e eventos",
      "Marcas de alta qualidade",
      "Produção e distribuição",
      3,
      101,
    );

    controllerPlanoNegocios.criarPlano(teste);
  }

  @override
  Widget build(BuildContext context) {
    planos = controllerPlanoNegocios.getPlano(idPessoa: 1);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("AppBar")),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text("Logado como:\n ${FirebaseAuth.instance.currentUser!.email}"),

          
          FutureBuilder<List<PlanoNegocios>>(
            future: planos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); 
              } else if (snapshot.hasError) {
                return Text("Erro ao carregar dados: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Nenhum plano encontrado");
              } else {
                var dados = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      var plano =
                          dados[index]; 
                      return InkWell(
                        onTap: () {    
                          print("Pessoa: ${plano.idPessoa}");
                        },
                        child: Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID Pessoa: ${plano.idPessoa}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          TextButton(onPressed: (){
            setState(() {
              teste();
            });
          }, child: Text("CRIE!!!")),
          SizedBox(height: 50,)
        ],
      
      ),
    );
  }
}
