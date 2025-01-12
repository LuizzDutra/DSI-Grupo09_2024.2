import 'package:app_gp9/swot/views/swot_created_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key, required String idUsuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 100),
            Text("SWOT", style: TextStyle(color: Color(0xFFFFFFFF))),
            SizedBox(width: 10),
          ],
        ),
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
              onTap: () {
                // Navegar para a tela de criação de análise SWOT
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CriarSwot(),
                  ),
                );
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
                                "Criar e Análisar",
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
          ],
        ),
      ),
    );
  }
}
