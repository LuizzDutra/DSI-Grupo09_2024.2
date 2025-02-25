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

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), 
      child: Scaffold(
        resizeToAvoidBottomInset: true, 
        appBar: AppBar(
          backgroundColor: Color(0xFF001800),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Color(0xFFFFFBE6),
        body: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.savings, color: Colors.white, size: 32),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          hintText: "Nome",
                          filled: true,
                          fillColor: Colors.grey[200],
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
                  ],
                ),

                SizedBox(height: 15),
                TextField(
                  controller: _valorFimController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                    hintText: "Insira o montante para a meta",
                    filled: true,
                    fillColor: Colors.grey[200],
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

                SizedBox(height: 15),
                InkWell(
                  onTap: () => _selecionarData(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 10),
                        Text("${_prazo.day}/${_prazo.month}/${_prazo.year}"),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),
                Text("Descrição", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: _descricaoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Insira uma breve descrição",
                    filled: true,
                    fillColor: Colors.grey[200],
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

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _criarMeta,
                  child: Text(
                    "Salvar meta",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C6E49),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
