import 'package:app_gp9/plano/view/planos_view_temp.dart';
import 'package:flutter/material.dart';

double altura(int valor) {
  return valor / 812;
}

double largura(int valor) {
  return valor / 375;
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color(0xFFEFFEE3),
          ),
    
          // Imagem à esquerda
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.19, top: 0.44 * screenHeight),
              child: Image.asset(
                'assets/images/Group_5.png',
                width: 0.38 * screenWidth,
                height: 0.11 * screenHeight,
              ),
            ),
          ),
    
          // Texto "Planeje hoje... Cresça sempre"
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 0), //
              child: SizedBox(
                  width:
                      screenWidth, // Ajuste para 90% da largura da tela (como no Figma)
                  height:
                      screenHeight, // Altura fixa de 116, conforme o Figma
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 182),
                        child: Text(
                          "Planeje hoje.",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 40,
                            color: Color(0xFF213E0D),
                          ),
                        ),
                      ),
                      Text(
                        "Cresça sempre.",
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 40,
                          color: Color(0xFF213E0D),
                        ),
                      )
                    ],
                  )),
            ),
          ),
    
          // Texto "Com as ferramentas certas..."
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight *
                      0.63), // Ajuste dinâmico baseado na altura
              child: SizedBox(
                width: screenWidth * 0.9, // Largura ajustada para 90% da tela
                child: const Text(
                  "Com as ferramentas certas, suas ideias\nganham raízes fortes e frutos duradouros.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF213E0D),
                    fontSize: 18,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              ),
            ),
          ),
    
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.35, right: screenWidth * 0.1),
              child: const Text(
                "Folha",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
    
          // Texto "Folha" mais abaixo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.8), // Ajuste dinâmico mais abaixo
              child: Text(
                "Folha",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
    
          // Imagem no canto superior direito
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 0, top: 0),
              child: Image.asset('assets/images/Subtract.png'),
            ),
          ),
    
          Positioned(
            top: 120,
            left: 17,
            child: Image.asset('assets/images/Group_3.png'),
          ),
          Positioned(
            top: 0.39 * screenHeight,
            left: screenWidth * 0.77,
            child: Image.asset('assets/images/Group_12.png'),
          ),
    
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(right: 0, bottom: screenHeight * 0.1),
              child: GestureDetector(
                child: Image.asset('assets/images/button.png'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PageView(
                        children: const [Page2(),Page3()],
                      )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFFFEFEE3).withOpacity(0.9),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 0.37 * screenHeight, left: 0.037 * screenWidth),
              child: Image.asset("assets/images/Rectangle_4.png"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.38 * screenHeight, left: 0.065 * screenWidth),
              child: Image.asset("assets/images/texto2.png"),
            ),
            Image.asset("assets/images/TopLeft.png"),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.06 * screenHeight, left: 0.5 * screenWidth),
              child: Image.asset("assets/images/TopRight.png"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.641 * screenWidth, top: 0.36 * screenHeight),
              child: Image.asset("assets/images/Group_12.png"),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(right: 0, bottom: screenHeight * 0.1),
                child: GestureDetector(
                  child: Image.asset('assets/images/button.png'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageView(
                          children: const [Page3()],
                        )));
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001800),
      ),
      backgroundColor: Color(0xFFFEFEE3),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(right: 0, bottom: screenHeight * 0.1),
              child: GestureDetector(
                child: Image.asset('assets/images/botao.png'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPlaceholder()));
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: altura(56) * screenHeight),
            child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset("assets/images/texto3.png")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/sol.png")),
          )
        ],
      ),
    );
  }
}

