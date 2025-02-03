import 'package:app_gp9/swot/BancodeDados/Swot_BD.dart';
import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:app_gp9/swot/models/swot_model.dart';
import 'package:app_gp9/swot/views/swot_main_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListasSwots extends StatefulWidget {
  late List<AnaliseSwot> swots;
  final Function onUpdate;
  late String idUsuario;

  ListasSwots({
    super.key,
    required this.swots,
    required this.onUpdate,
    required this.idUsuario,
  });

  @override
  State<ListasSwots> createState() => _ListasSwotsState();
}

class _ListasSwotsState extends State<ListasSwots> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.swots.length,
      itemBuilder: (context, index) {
        var swots = widget.swots[index];
        return Dismissible(
          key: Key(swots.referencia.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) async {
            showDialog<void>(
              context: context,
              barrierDismissible:
                  false, 
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exclusão de Swot'),
                  content: Text("Deseja excluir o Swot ${swots.nome}?"),
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
                        await controllerSwot.deleteSwot(
                            swot: swots, idUsuario: widget.idUsuario);
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
                                builder: (context) => SwotMainView(
                                      swot: swots,
                                      
                                    )),
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
                                Text("${swots.nome}",
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
