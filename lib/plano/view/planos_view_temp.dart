import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:app_gp9/plano/Controller/plano_negocio_controller.dart';
import 'package:app_gp9/plano/view/listagemPlanos.dart';
import 'package:app_gp9/plano/view/planoCreate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

late var listaDePlanos;

class MyPlaceholder extends StatefulWidget {
  const MyPlaceholder({super.key});

  @override
  State<MyPlaceholder> createState() => _MyPlaceholderState();
}

class _MyPlaceholderState extends State<MyPlaceholder> with RouteAware {
  final user = FirebaseAuth.instance.currentUser?.uid;
  User? usuario = FirebaseAuth.instance.currentUser;

  final controller = ControllerPlanoNegocios();

  void atualizarDados() {
    setState(() {});
  }

  Future<List<PlanoNegocios>> _obterPlanos({required String idUsuario}) async {
    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);

    List<PlanoNegocios> lista = [];

    for (var chave in pessoa!.planos!.keys) {
      if (chave != 'total') {
        var plano =
            await controller.getPlano(referencia: pessoa.planos![chave]);
        lista.add(plano);
      }
    }
    listaDePlanos = lista;
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Plano de negócios",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        backgroundColor: Color(0xFF001800),
      ),
      backgroundColor: Color(0xE5FEFEE3),
      body: Container(
        padding: EdgeInsets.only(left: 25),
        child: Column(
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanoCreate(
                      controller: controller,
                      planos: listaDePlanos,
                    ),
                  ),
                ).then((event) {
                  setState(() {});
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        // Círculo
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2C6E49),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 25,
                        child: Container(
                          width: 280.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF2C6E49),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                              ),
                              Text(
                                "Criar Plano",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 18,
                        child: Image.asset('assets/images/Logo.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: FutureBuilder<List<PlanoNegocios>>(
          future: _obterPlanos(idUsuario: user!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Text("Erro ao carregar dados: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Nenhum plano encontrado"));
            } else {
              var resultado = snapshot.data!;
              //Retorna uma lista com planos de negócios
              return ListagemPlanos(
                dados: resultado,
                onUpdate: atualizarDados,
                idUsuario: user!,
                controller: controller,
              );
            }
          },
        ),
      ),
    );
  }
}
