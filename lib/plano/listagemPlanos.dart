import 'package:app_gp9/plano/plano_negocios.dart';
import 'package:flutter/material.dart';

class ListagemPlanos extends StatelessWidget {

  late List<PlanoNegocios> dados;

  ListagemPlanos({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dados.length,
      itemBuilder: (context, index) {
        var plano = dados[index];
        return Container(
          margin: EdgeInsets.only(top: 15),
          child: SizedBox(
            height: 132,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: InkWell(
                      onTap: () => print("Teste ${plano.descNome}"),
                      child: Card(
                        color: Color(0xFFEDE9B2),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 23, left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${plano.descNome}",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text("Canvas", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 3,
                    bottom: 1,
                    child: Container(
                      width: 11.0,
                      height: 131,
                      decoration: BoxDecoration(
                        color: Color(0xFF82B135),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
