import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/metas_controller.dart';

class CriarMetaView extends StatefulWidget {
  const CriarMetaView({super.key});

  @override
  State<CriarMetaView> createState() => _CriarMetaViewState();
}

class _CriarMetaViewState extends State<CriarMetaView> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorInicioController = TextEditingController();
  final TextEditingController _valorFimController = TextEditingController();
  DateTime _prazo = DateTime.now();

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _prazo,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada != null) {
      setState(() {
        _prazo = dataSelecionada;
      });
    }
  }

  void _criarMeta() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    double valorInicio = double.tryParse(_valorInicioController.text) ?? 0;
    double valorFim = double.tryParse(_valorFimController.text) ?? 0;

    if (titulo.isEmpty || valorFim == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos corretamente!")),
      );
      return;
    }

    await ControladorMetas.criarMeta(
      titulo: titulo,
      descricao: descricao,
      valorInicio: valorInicio,
      valorFim: valorFim,
      prazo: _prazo,
    );

    Navigator.pop(context, true); // Fecha a tela após criar a meta
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Criar Meta"),
          backgroundColor: Colors.green[700],
        ),
        backgroundColor: Color(0xE5FEFEE3),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Título", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _tituloController),

              SizedBox(height: 15),
              Text("Descrição", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _descricaoController),

              SizedBox(height: 15),
              Text("Valor Inicial", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _valorInicioController, keyboardType: TextInputType.number),

              SizedBox(height: 15),
              Text("Valor Final", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _valorFimController, keyboardType: TextInputType.number),

              SizedBox(height: 15),
              Text("Prazo", style: TextStyle(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => _selecionarData(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("${_prazo.day}/${_prazo.month}/${_prazo.year}"),
                ),
              ),

              Spacer(),
              ElevatedButton(
                onPressed: _criarMeta,
                child: Text("Criar Meta"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
