import 'package:app_gp9/custom_colors.dart';
import 'package:app_gp9/empresa.dart';
import 'package:flutter/material.dart';

class Detalhes extends StatefulWidget {
  final Empresa empresa;
  const Detalhes({super.key, required this.empresa});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors[6],
      appBar: AppBar(
        title: Text("Detalhes"),
        centerTitle: true,
        iconTheme: IconThemeData(size: 35, color: Colors.white),
        backgroundColor: customColors[7],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(title: "Nome do Negócio", text: widget.empresa.nomeNegocio),
            CustomText(title: "Segmento", text: widget.empresa.segmento,),
            CustomText(title: "Tempo do Operação em Anos", text: widget.empresa.tempoOperacaoAnos.toString()),
            CustomText(title: "Número de Funcionários", text: widget.empresa.numFuncionarios.toString()),
            CustomText(title: "Descrição", text: widget.empresa.descricao,)
          ],
        ),
      ),
    );
  }
}


class CustomText extends StatelessWidget{
  final String title;
  
  final String text;
  
  const CustomText({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Text(
          "$title: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 20),
          softWrap: true,
        )
      ],
    );
  }
}
