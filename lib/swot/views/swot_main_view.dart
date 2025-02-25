import 'package:app_gp9/swot/BancodeDados/Swot_BD.dart';
import 'package:app_gp9/swot/controller/swot_controller.dart';
import 'package:app_gp9/swot/views/swot_ameaca_view.dart';
import 'package:app_gp9/swot/views/swot_forca_view.dart';
import 'package:app_gp9/swot/views/swot_fraqueza_view.dart';
import 'package:app_gp9/swot/views/swot_oportuni_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/swot/models/swot_model.dart';

class SwotMainView extends StatefulWidget {
  final AnaliseSwot swot;

  const SwotMainView({
    super.key,
    required this.swot,
  });

  @override
  State<SwotMainView> createState() => _SwotMainViewState();
}

class _SwotMainViewState extends State<SwotMainView> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  late DocumentReference? referencia;

  @override
  void initState() {
    super.initState();
    referencia =
        FirebaseFirestore.instance.collection('Swots').doc(widget.swot.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SWOT - ${widget.swot.nome}",
                style: TextStyle(color: Color(0xFFFFFFFF))),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        backgroundColor: Color(0xFF001800),
        centerTitle: true,
      ),
      backgroundColor: Color(0xE5FEFEE3),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem e Texto "Ambiente Interno"
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/squares.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8), // Espaçamento entre a imagem e o texto
                  Text(
                    'Ambiente Interno',
                    style: TextStyle(
                      fontFamily: 'poppins-regular',
                      fontSize: 20,
                      color: Color(0xFF001800),
                    ),
                  ),
                ],
              ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 30,
              children: [
                // Container "Forças"
                GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForcaView(
                          referenciaDocumento: referencia!,
                        ),
                      ),
                    ),
                    child: CustomContainer(
                      title: 'Forças',
                      symbol: 'S',
                      bgColor: Colors.pink,
                      textColor: Color(0xFFFFFFFF),
                    ),
                  ),
                // Container "Fraquezas"
                GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FraquezaView(
                          referenciaDocumento: referencia!,
                        ),
                      ),
                    ),
                    child: CustomContainer(
                      title: 'Fraquezas',
                      symbol: 'W',
                      bgColor: const Color.fromARGB(255, 251, 255, 0),
                      textColor: Color(0xFFFFFFFF),
                    ),
                  ),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.06,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/squares.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8), // Espaçamento entre a imagem e o texto
                  Text(
                    'Ambiente Externo',
                    style: TextStyle(
                      fontFamily: 'poppins-regular',
                      fontSize: 20,
                      color: Color(0xFF001800),
                    ),
                  ),
                ],
              ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 30,
              children: [
                // Container "Oportunidades"
                GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OportuniView(
                          referenciaDocumento: referencia!,
                        ),
                      ),
                    ),
                    child: CustomContainer(
                      title: 'Oportunidades',
                      symbol: 'O',
                      bgColor: Colors.blue,
                      textColor: Color(0xFFFFFFFF),
                    ),
                  ),
                // Container "Ameaças"
                GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AmeacaView(
                          referenciaDocumento: referencia!,
                        ),
                      ),
                    ),
                    child: CustomContainer(
                      title: 'Ameaças',
                      symbol: 'T',
                      bgColor: const Color.fromARGB(255, 253, 17, 0),
                      textColor: Color(0xFFFFFFFF),
                    ),
                  ),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.06,),
          ],
        ),
      );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final String symbol;
  final Color bgColor;
  final Color textColor;

  const CustomContainer({
    required this.title,
    required this.symbol,
    required this.bgColor,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 133,
      height: 168,
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  fontFamily: 'poppins-regular',
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4),
            color: Colors.green[900],
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
