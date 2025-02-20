import 'package:flutter/material.dart';
import '../controller/metas_controller.dart';
import '../models/meta_model.dart';
import 'metas_detalhes_view.dart';

class ListasMetas extends StatefulWidget {
  final List<Meta> metas;
  final Function onUpdate;

  const ListasMetas({
    super.key,
    required this.metas,
    required this.onUpdate,
  });

  @override
  State<ListasMetas> createState() => _ListasMetasState();
}

class _ListasMetasState extends State<ListasMetas> {
  double _calcularProgresso(Meta meta) {
    double progresso = ((meta.valorAtual - meta.valorInicio) / (meta.valorFim - meta.valorInicio)) * 100;
    if (progresso.isNaN || progresso.isInfinite || progresso < 0) return 0;
    if (progresso > 100) return 100;
    return progresso;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.metas.length,
      itemBuilder: (context, index) {
        var meta = widget.metas[index];
        double progresso = _calcularProgresso(meta);

        return Dismissible(
          key: Key(meta.referencia.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            bool? confirmar = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Excluir Meta"),
                  content: Text("Tem certeza que deseja excluir '${meta.titulo}'?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false), 
                      child: Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true), 
                      child: Text("Excluir", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
            return confirmar ?? false; 
          },
          onDismissed: (direction) async {
            await ControladorMetas.excluirMeta(referencia: meta.referencia);
            widget.onUpdate(); 
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
                              builder: (context) => MetasDetalhesView(meta: meta),
                            ),
                          ).then((_) => widget.onUpdate());
                        },
                        child: Card(
                          color: Color(0xFFEDE9B2),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                               
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.attach_money, color: Colors.green[700], size: 28),
                                ),
                                SizedBox(width: 15),

                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meta.titulo,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Meta",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 8),
                                      
                                      Stack(
                                        children: [
                                          Container(
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                          Container(
                                            height: 8,
                                            width: (MediaQuery.of(context).size.width - 150) * (progresso / 100),
                                            decoration: BoxDecoration(
                                              color: progresso >= 100 ? Colors.green : Colors.lightGreen,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "${progresso.toStringAsFixed(0)}%",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
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
