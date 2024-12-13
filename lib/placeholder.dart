import 'package:app_gp9/plano_negocios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyPlaceholder extends StatefulWidget {
  const MyPlaceholder({super.key});

  @override
  State<MyPlaceholder> createState() => _MyPlaceholderState();
}

class _MyPlaceholderState extends State<MyPlaceholder> {
  
  late List<PlanoNegocios> dadosLocais = []; // Lista local
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    // Carregar dados uma vez no início
    controllerPlanoNegocios.getPlano(idPessoa: 1).then((dados) {
      setState(() {
        dadosLocais = dados; // Armazene a lista localmente
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Plano de Negócios",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            )),
            SizedBox(
              width: 45,
            )
          ],
        ),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        backgroundColor: Color(0xFF001800),
        centerTitle: false,
      ),
      backgroundColor: Color(0xE5FEFEE3),
      body: Column(
        children: [
          FutureBuilder<List<PlanoNegocios>>(
            future: Future.value(dadosLocais),
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
                      var plano = dados[index];
                      return SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Dismissible(
                          key: Key(plano.idPessoa.toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {  
                            //controllerPlanoNegocios.deletarPlano() #TENHO QUE FAZER ISSO AQUI DEPOIS!!!
                            setState(() {
                              dados.removeAt(index);
                            });
                          },
                          child: InkWell(
                              onTap: () {
                                print("Pessoa: ${plano.idPessoa}");
                              },
                              child: Card(
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Color(0xFF213E0D),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Usando um Stack para controlar a posição da imagem
                                      Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment
                                                .topRight, // Posiciona no topo centralizado
                                            child: InkWell(
                                              onTap: () {
                                                print("Helo People");
                                              },
                                              child: Image.asset(
                                                'assets/images/lixeirinha.png',
                                                width: 50,
                                                height: 25,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 15,
                                            left: 160,
                                            child: Image.asset(
                                              'assets/images/regando.png',
                                              scale: 0.9,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Teste",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xB3FFFFFF))),
                                              SizedBox(height: 20),
                                              Text(
                                                'ID Pessoa: ${plano.idPessoa}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 32),
                                              Text(
                                                "13/12/2024",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 30)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
