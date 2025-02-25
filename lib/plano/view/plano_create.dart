import 'package:app_gp9/plano/Controller/plano_negocio_controller.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanoCreate extends StatefulWidget {
  final ControllerPlanoNegocios controller;
  final List<PlanoNegocios> planos;
  const PlanoCreate(
      {super.key, required this.controller, required this.planos});

  @override
  State<PlanoCreate> createState() => _PlanoCreateState();
}

class _PlanoCreateState extends State<PlanoCreate> {
  final TextEditingController _nomeCanvas = TextEditingController();
  String mensagem = "Qual será o nome do seu Canvas?";
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
            title: const Text(''),
            backgroundColor: Color(0xFF001800),
            toolbarHeight: 96,
            iconTheme: IconThemeData(color: Color(0xFFFFFFFF))),
        body: Container(
          padding: EdgeInsets.only(top: 22),
          child: Column(
            children: [
              Center(
                  child: Text(
                "Crie o seu canvas",
                style: TextStyle(fontFamily: "Poppins", fontSize: 40),
              )),
              SizedBox(
                height: 39,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      mensagem,
                      style: TextStyle(
                          fontFamily: "Poppins", color: Color(0x94262926)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19, right: 24),
                child: TextField(
                  controller: _nomeCanvas,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color(0xFF262926),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nome do seu Canvas',
                    filled: true,
                    fillColor: Color(0xFFEDE9B2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  if (_nomeCanvas.text != "") {
                    for (var temp in widget.planos) {
                      if (_nomeCanvas.text == temp.descNome) {
                        setState(() {
                          mensagem = "Plano já existente";
                        });
                        return;
                      }
                    }
                    await widget.controller.createEmptyPlan(
                        nome: _nomeCanvas.text, idUsuario: user!);

                    setState(() {
                      mensagem = "Plano ${_nomeCanvas.text} registado!";
                      _nomeCanvas.text = "";
                    });
                  } else {
                    setState(() {
                      mensagem = "O nome não pode ser vazio";
                    });
                  }
                },
                child: Container(
                  height: 86,
                  color: Color(0xFF2C6E49),
                  child: Center(
                      child: Text(
                    "Criar Canvas",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 36,
                        color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
