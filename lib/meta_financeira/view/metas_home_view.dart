import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/metas_controller.dart';
import '../models/meta_model.dart';
import 'metas_criar_view.dart';
import 'metas_list_view.dart';

class MetasHomeView extends StatefulWidget {
  const MetasHomeView({super.key});

  @override
  State<MetasHomeView> createState() => _MetasHomeViewState();
}

class _MetasHomeViewState extends State<MetasHomeView> {
  final user = FirebaseAuth.instance.currentUser?.uid;

  void atualizarDados() {
    setState(() {});
  }

  Future<List<Meta>> _obterMetas() async {
    return await ControladorMetas.getMetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40),
            Text("Metas Financeiras", style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001800),
      ),
      backgroundColor: Color(0xE5FEFEE3),
      body: Container(
        padding: EdgeInsets.only(left: 25),
        child: Column(
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navegar para a tela de criação de meta financeira
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CriarMetaView(),
                  ),
                ).then((event) {
                  setState(() {}); // Atualiza a tela após a criação da meta
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
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
                              SizedBox(width: 80),
                              Text(
                                "Criar Meta",
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
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder<List<Meta>>(
          future: _obterMetas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro ao carregar metas: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Nenhuma meta cadastrada."));
            } else {
              var resultado = snapshot.data!;
              return ListasMetas(
                metas: resultado,
                onUpdate: atualizarDados,
              );
            }
          },
        ),
      ),
    );
  }
}
