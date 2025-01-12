import 'package:app_gp9/swot/BrancodeDados/Swot_BD.dart';
import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CriarSwot extends StatefulWidget {
  CriarSwot({super.key});

  @override
  State<CriarSwot> createState() => _CriarSwotState();
}

class _CriarSwotState extends State<CriarSwot> {
  final TextEditingController _tituloSwot = TextEditingController();
  final controllerSwot _swotController = controllerSwot();
  String mensagem = 'Qual será o título do seu SWOT?';
  final user = FirebaseAuth.instance.currentUser?.uid;
  final bdSwot _swotBD = bdSwot();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Color(0xFF001800),
          toolbarHeight: 96,
          iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: Color(0xE5FEFEE3),
        body: Container(
          padding: EdgeInsets.only(top: 22),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Crie o seu SWOT",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 40),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      mensagem,
                      style: TextStyle(
                          fontFamily: 'Poppins', color: Color(0x94262926)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19, right: 40),
                child: TextField(
                  controller: _tituloSwot,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF262926),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Título do SWOT',
                    filled: true,
                    fillColor: Color(0xFFEDE9B2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  if (_tituloSwot.text.isNotEmpty) {
                    // Verifica se o usuário está logado
                    if (user != null) {
                      // Criar análise SWOT no Controller
                      await controllerSwot.createEmptySwot(
                        nome: _tituloSwot.text,
                        idUsuario: user!,
                        
                      );

                      setState(() {
                        mensagem = 'Análise SWOT criada com sucesso!';
                      });
                    } else {
                      setState(() {
                        mensagem = 'Erro: usuário não logado.';
                      });
                    }
                  } else {
                    setState(() {
                      mensagem = 'Por favor, insira um título para o SWOT.';
                    });
                  }
                },
                child: Container(
                  height: 86,
                  color: Color(0xFF2C6E49),
                  child: Center(
                    child: Text(
                      'Criar Canvas',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
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
