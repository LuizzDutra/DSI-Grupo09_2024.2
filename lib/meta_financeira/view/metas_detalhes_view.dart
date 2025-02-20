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
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late DateTime _prazo;
  double _valorAtual = 0;
  bool _mostrarCampoValor = false;
  bool _adicionandoDinheiro = true;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.meta.descricao);
    _valorController = TextEditingController();
    _prazo = widget.meta.prazo;
    _valorAtual = widget.meta.valorAtual;

    FirebaseFirestore.instance
        .collection('Metas')
        .doc(widget.meta.referencia.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          _valorAtual = snapshot.get('valorAtual') ?? 0;
        });
      }
    });
  }

  double _calcularProgresso() {
    double progresso = ((_valorAtual - widget.meta.valorInicio) /
            (widget.meta.valorFim - widget.meta.valorInicio)) *
        100;
    if (progresso.isNaN || progresso.isInfinite || progresso < 0) return 0;
    if (progresso > 100) return 100;
    return progresso;
  }

  void _alterarValor(bool isAdicionando) {
    setState(() {
      _mostrarCampoValor = true;
      _adicionandoDinheiro = isAdicionando;
      _valorController.clear();
    });
  }

  Future<void> _confirmarAlteracao() async {
    double valor = double.tryParse(_valorController.text) ?? 0;

    if (valor > 0) {
      double novoValor = _adicionandoDinheiro ? _valorAtual + valor : _valorAtual - valor;
      if (novoValor < 0) novoValor = 0;

      setState(() {
        _valorAtual = novoValor;
        _mostrarCampoValor = false;
      });

      await FirebaseFirestore.instance
          .collection('Metas')
          .doc(widget.meta.referencia.id)
          .update({'valorAtual': novoValor});
    }
  }

  @override
  Widget build(BuildContext context) {
    double valorFaltante = widget.meta.valorFim - _valorAtual;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001800),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFFFFFBE6),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Descrição", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Container(
              height: 120,
              child: TextField(
                controller: _descricaoController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEDE9B2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Meta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("R\$ ${widget.meta.valorFim.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, color: Colors.green[700])),
                    SizedBox(height: 5),
                    Text("Faltam", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("R\$ ${valorFaltante.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, color: Colors.red[700])),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: _calcularProgresso() / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _calcularProgresso() >= 100 ? Colors.green : Colors.blue),
                        strokeWidth: 8,
                      ),
                    ),
                    Text("${_calcularProgresso().toStringAsFixed(0)}%", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),

            Text("Dinheiro Acumulado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text("R\$ ${_valorAtual.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _alterarValor(false),
                  child: Text("Retirar", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () => _alterarValor(true),
                  child: Text("Adicionar", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ],
            ),

            if (_mostrarCampoValor) ...[
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _valorController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Valor",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmarAlteracao,
                  child: Text("Confirmar"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
