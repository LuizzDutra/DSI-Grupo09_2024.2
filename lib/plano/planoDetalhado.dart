import 'package:flutter/material.dart';

class PlanoDetalhadoPrimeiraPagina extends StatelessWidget {
  const PlanoDetalhadoPrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Color(0xFF001800),
        toolbarHeight: 96,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 23, right: 24),
          child: Column(
            children: [
              SizedBox(
                height: 23,
              ),
              Row(
                children: [Text('Texto 1'), Spacer(), Text("Texto 2")],
              ),
              SizedBox(
                height: 13,
              ),
              listagem(
                categoria: "Parcerias",
                fundo: Color(0xFFA8D0FF),
                borda: Color(0xFF0E1BAB),
                largura: double.infinity,
                altura: 99,
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  listagem(
                      categoria: "Clientes",
                      fundo: Color(0xFFA8D0FF),
                      borda: Color(0xFF0E1BAB),
                      largura: 170,
                      altura: 107),
                  Spacer(),
                  listagem(
                      categoria: "Canais",
                      fundo: Color(0xFFA8D0FF),
                      borda: Color(0xFF0E1BAB),
                      largura: 170,
                      altura: 107)
                ],
              ),
              SizedBox(
                height: 23,
              ),
              listagem(
                  categoria: "Proposta de valor",
                  fundo: Color(0xFFFEB5B5),
                  borda: Color(0xFF7F0E0E),
                  largura: double.infinity,
                  altura: 99),
              SizedBox(
                height: 23,
              ),
              Row(
                children: [
                  listagem(
                      categoria: "Recursos",
                      fundo: Color(0xFFA2E79D),
                      borda: Color(0xFF045802),
                      largura: 170,
                      altura: 107),
                  Spacer(),
                  listagem(
                      categoria: "Recursos",
                      fundo: Color(0xFFA2E79D),
                      borda: Color(0xFF045802),
                      largura: 170,
                      altura: 107),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              listagem(
                  categoria: "Relacionamento",
                  fundo: Color(0xFFEDE9B2),
                  borda: Color(0xFF7F7102),
                  largura: double.infinity,
                  altura: 99)
            ],
          )),
    );
  }
}

class PlanoDetalhadoSegundaPagina extends StatelessWidget {
  const PlanoDetalhadoSegundaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Color(0xFF001800),
        toolbarHeight: 96,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 45, left: 26, right: 22),
        child: Row(
          children: [
            listagem(
                categoria: 'Receita',
                fundo: Color(0xFFEDE9B2),
                borda: Color(0xFF7F7102),
                largura: 170,
                altura: 107),
            Spacer(),
            listagem(
                categoria: 'Custos',
                fundo: Color(0xFFEDE9B2),
                borda: Color(0xFF7F7102),
                largura: 170,
                altura: 107),
          ],
        ),
      ),
    );
  }
}

class listagem extends StatelessWidget {
  late String categoria;
  late Color fundo;
  late Color borda;
  late double largura;
  late double altura;

  listagem(
      {super.key,
      required this.categoria,
      required this.fundo,
      required this.borda,
      required this.largura,
      required this.altura});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: largura,
      height: altura,
      padding: EdgeInsets.only(left: 14, right: 16),
      decoration: BoxDecoration(
        color: fundo,
        border: Border.all(
          color: borda,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Row(children: [
            SizedBox(
              width: 11,
            ),
            Text(
              categoria,
              style: TextStyle(color: borda),
            )
          ]),
          SizedBox(
            height: 9,
          ),
          //To-Do Listview.builder with 2.
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 9),
            height: 21,
            color: borda,
            child: Text(
              "Parceiro 1",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 9),
            height: 21,
            color: borda,
            child: Text(
              "Parceiro 2",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
