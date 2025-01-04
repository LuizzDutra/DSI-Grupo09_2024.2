import 'package:app_gp9/plano/plano_negocios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanoEdicao extends StatefulWidget {
  late Map<String, dynamic>? atributos;
  late DocumentReference? referencia;
  late List<ListaAtributos> temp = [];

  late String titulo;
  PlanoEdicao(
      {super.key,
      required this.atributos,
      required this.titulo,
      required this.referencia});

  @override
  State<PlanoEdicao> createState() => _PlanoEdicaoState();
}

class _PlanoEdicaoState extends State<PlanoEdicao> {
  Map<String, dynamic> gerarMapComContador(List lista) {
    int contador = 0;
    Map<String, dynamic> map = {};

    for (var x in lista) {
      map['${contador+1}'] = x;
      contador += 1;
    }

    map['total'] = contador;
    return map;
  }

  @override
  void initState() {
    for (var x in widget.atributos!.values) {
      if (x is String) {  
        widget.temp.add(ListaAtributos(texto: x));
      }
    }
    super.initState();
  }

  void adicionarAtributo(ListaAtributos novoAtributo) {
    setState(() {
      widget.temp.add(novoAtributo);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    print(widget.atributos);

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        List<String> auxiliar = [];

        for(var x in widget.temp){
          if(x._Controller.text != ""){
          auxiliar.add(x._Controller.text);
          }
        } 
        
        Map<String, dynamic> update = gerarMapComContador(auxiliar);
        
        Map<String, dynamic> auxiliar_vai_pro_banco = {
          widget.titulo: update
        };

        await bdPlanoNegocios.updatePlan(reference: widget.referencia, dados: auxiliar_vai_pro_banco);
        
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
          toolbarHeight: 96,
          backgroundColor: Color(0xFF001800),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 27, top: 33, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  widget.titulo,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      color: Color(0xFF001800)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.temp.length,
                        itemBuilder: (context, index) {
                          return widget.temp[index];
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Ação do botão
                          adicionarAtributo(ListaAtributos(texto: ""));
                        },
                        child: Text('Adicionar'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaAtributos extends StatelessWidget {
  late String texto;
  final TextEditingController _Controller = TextEditingController();
  ListaAtributos({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    _Controller.text = texto;
    return GestureDetector(
      onTap: () {
        print(texto);
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.only(left: 10),
        color: Colors.green,
        width: double.infinity,
        child: TextField(
          controller: _Controller,
          canRequestFocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
