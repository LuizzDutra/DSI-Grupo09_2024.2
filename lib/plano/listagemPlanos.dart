import 'package:app_gp9/plano/planoDetalhado.dart';
import 'package:app_gp9/plano/plano_negocios.dart';
import 'package:flutter/material.dart';

class ListagemPlanos extends StatefulWidget {
  late List<PlanoNegocios> dados;
  final Function onUpdate;
  late String idUsuario;

  ListagemPlanos(
      {super.key,
      required this.dados,
      required this.onUpdate,
      required this.idUsuario});

  @override
  State<ListagemPlanos> createState() => _ListagemPlanosState();
}

class _ListagemPlanosState extends State<ListagemPlanos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.dados.length,
      itemBuilder: (context, index) {
        var plano = widget.dados[index];
        return Dismissible(
          key: Key(plano.referencia.toString()),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) async {
            showDialog<void>(
              context: context,
              barrierDismissible:
                  false, // Evita fechar ao clicar fora do diálogo
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exclusão de plano'),
                  content: Text("Deseja excluir o plano ${plano.descNome}?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); 
                        widget.onUpdate();
                      },
                      child: Text('Não'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await controllerPlanoNegocios.deletePlano(
                            plano: plano, idUsuario: widget.idUsuario);
                        Navigator.of(context).pop(); 
                        widget.onUpdate();
                        
                      },
                      child: Text('Sim'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 15),
            child: SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PlanoDetalhadoPrimeiraPagina(plano: plano)),
                          ).then((teste) {
                            widget.onUpdate();
                          });
                        },
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
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
          ),
        );
      },
    );
  }
}
