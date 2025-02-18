import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/metas_controller.dart';
import '../models/meta_model.dart';

class MetasDetalhesView extends StatefulWidget {
  final Meta meta;

  const MetasDetalhesView({super.key, required this.meta});

  @override
  State<MetasDetalhesView> createState() => _MetasDetalhesViewState();
}

class _MetasDetalhesViewState extends State<MetasDetalhesView> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorAtualController;
  late TextEditingController _valorFimController;
  late DateTime _prazo;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.meta.titulo);
    _descricaoController = TextEditingController(text: widget.meta.descricao);
    _valorAtualController = TextEditingController(text: widget.meta.valorAtual.toString());
    _valorFimController = TextEditingController(text: widget.meta.valorFim.toString());
    _prazo = widget.meta.prazo;
  }

  void _atualizarMeta() async {
    double novoValorAtual = double.tryParse(_valorAtualController.text) ?? widget.meta.valorAtual;
    double novoValorFim = double.tryParse(_valorFimController.text) ?? widget.meta.valorFim;

    await ControladorMetas.alterarMeta(
      referencia: widget.meta.referencia,
      novosDados: {
        'titulo': _tituloController.text,
        'descricao': _descricaoController.text,
        'valorAtual': novoValorAtual,
        'valorFim': novoValorFim,
        'prazo': Timestamp.fromDate(_prazo),
      },
    );

    Navigator.pop(context, true); // Retorna para a tela anterior após atualização
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Meta"),
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
            Text("Valor Atual", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _valorAtualController, keyboardType: TextInputType.number),

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
              onPressed: _atualizarMeta,
              child: Text("Atualizar Meta"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
