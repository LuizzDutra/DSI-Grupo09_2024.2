import 'package:flutter/material.dart';

class Clientes extends StatefulWidget {
  Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        print(_controller.text); //Consigo recuperar
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "ATLAS",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF001800),
        ),
        backgroundColor: Color(0xFFFEFEE3),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF82B135),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Card(
                        color: Color(0xFF82B135),
                        child: Text("Clientes"),
                      ),
                      Text("Valor"),
                      Text("Canais"),
                      Text("Relacionamentos"),
                      Text("..."),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.9, top: 39),
                    child: Row(
                      children: [
                        Text(
                          "Quem são os meus clientes?\n(Segmento de clientes)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.9, top: 16, right: 24),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                "Identifique quem você quer atender: seu público-alvo. Pense nas pessoas que mais precisam do seu produto ou serviço. Quem são elas? Onde estão? O que elas valorizam?",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xFF393939))))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              hintText: "Clique para escrever",
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(fontStyle: FontStyle.italic)),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
