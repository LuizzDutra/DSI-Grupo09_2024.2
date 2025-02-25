import 'package:app_gp9/custom_colors.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:app_gp9/plano/Controller/plano_negocio_controller.dart';
import 'package:app_gp9/plano/view/planoEdicao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlanoDetalhadoPrimeiraPagina extends StatefulWidget {
  late PlanoNegocios plano;
  final ControllerPlanoNegocios controller;

  PlanoDetalhadoPrimeiraPagina(
      {super.key, required this.plano, required this.controller});

  @override
  State<PlanoDetalhadoPrimeiraPagina> createState() =>
      _PlanoDetalhadoPrimeiraPaginaState();
}

class _PlanoDetalhadoPrimeiraPaginaState
    extends State<PlanoDetalhadoPrimeiraPagina> {
  void atualizarTela() async {
    var dados = await widget.controller.getPlano(referencia: widget.plano.referencia);

    setState(() {
      widget.plano = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors[6]!,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Color(0xFF001800),
        toolbarHeight: 96,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 23, right: 24),
          child: Column(
            children: [
              SizedBox(
                height: 23,
              ),
              Row(
                children: [
                  Text(
                    widget.plano.descNome!,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 40),
                  ),
                  Spacer(),
                  Image.asset('assets/images/tresPontos.png')
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Listagem(
                categoria: "Parcerias",
                fundo: Color(0xFFA8D0FF),
                borda: Color(0xFF0E1BAB),
                largura: double.infinity,
                altura: 99,
                conteudo: widget.plano.descParcerias,
                onUpdate: atualizarTela,
                reference: widget.plano.referencia,
                controller: widget.controller,
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Listagem(
                      categoria: "Clientes",
                      fundo: Color(0xFFA8D0FF),
                      borda: Color(0xFF0E1BAB),
                      largura: 170,
                      altura: 107,
                      conteudo: widget.plano.descClientes,
                      onUpdate: atualizarTela,
                      reference: widget.plano.referencia,
                      controller: widget.controller),
                  Spacer(),
                  Listagem(
                      categoria: "Canais",
                      fundo: Color(0xFFA8D0FF),
                      borda: Color(0xFF0E1BAB),
                      largura: 170,
                      altura: 107,
                      conteudo: widget.plano.descCanais,
                      onUpdate: atualizarTela,
                      reference: widget.plano.referencia,
                      controller: widget.controller)
                ],
              ),
              SizedBox(
                height: 23,
              ),
              Listagem(
                  categoria: "Proposta de valor",
                  fundo: Color(0xFFFEB5B5),
                  borda: Color(0xFF7F0E0E),
                  largura: double.infinity,
                  altura: 99,
                  conteudo: widget.plano.descValor,
                  onUpdate: atualizarTela,
                  reference: widget.plano.referencia,
                  controller: widget.controller),
              SizedBox(
                height: 23,
              ),
              Row(
                children: [
                  Listagem(
                      categoria: "Recursos",
                      fundo: Color(0xFFA2E79D),
                      borda: Color(0xFF045802),
                      largura: 170,
                      altura: 107,
                      conteudo: widget.plano.descRecursos,
                      onUpdate: atualizarTela,
                      reference: widget.plano.referencia,
                      controller: widget.controller),
                  Spacer(),
                  Listagem(
                      categoria: "Atividades",
                      fundo: Color(0xFFA2E79D),
                      borda: Color(0xFF045802),
                      largura: 170,
                      altura: 107,
                      conteudo: widget.plano.descAtividades,
                      onUpdate: atualizarTela,
                      reference: widget.plano.referencia,
                      controller: widget.controller),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Listagem(
                  categoria: "Relacionamento",
                  fundo: Color(0xFFEDE9B2),
                  borda: Color(0xFF7F7102),
                  largura: double.infinity,
                  altura: 99,
                  conteudo: widget.plano.descRelacionamentos,
                  onUpdate: atualizarTela,
                  reference: widget.plano.referencia,
                  controller: widget.controller)
            ],
          )),
    );
  }
}

class Listagem extends StatefulWidget {
  late String categoria;
  late Color fundo;
  late Color borda;
  late double largura;
  late double altura;
  late Map<String, dynamic>? conteudo;
  final VoidCallback onUpdate;
  late DocumentReference? reference;
  final ControllerPlanoNegocios controller;

  Listagem(
      {super.key,
      required this.categoria,
      required this.fundo,
      required this.borda,
      required this.largura,
      required this.altura,
      required this.conteudo,
      required this.onUpdate,
      required this.reference,
      required this.controller});

  @override
  State<Listagem> createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlanoEdicao(
                  atributos: widget.conteudo,
                  titulo: widget.categoria,
                  referencia: widget.reference,
                  controller: widget.controller)),
        ).then((event) {
          widget.onUpdate();
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: widget.largura,
        height: widget.altura,
        padding: EdgeInsets.only(left: 14, right: 16),
        decoration: BoxDecoration(
          color: widget.fundo,
          border: Border.all(
            color: widget.borda,
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
                widget.categoria,
                style: TextStyle(color: widget.borda),
              )
            ]),
            SizedBox(
              height: 9,
            ),
            if (widget.conteudo!.length >= 2)
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 9),
                height: 21,
                color: widget.borda,
                child: Text(
                  widget.conteudo!['1'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            SizedBox(
              height: 6,
            ),
            if (widget.conteudo!.length >= 3)
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 9),
                height: 21,
                color: widget.borda,
                child: Text(
                  widget.conteudo!['2'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
