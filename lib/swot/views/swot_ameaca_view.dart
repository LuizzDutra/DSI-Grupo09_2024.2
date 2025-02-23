import 'dart:async';

import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AmeacaView extends StatefulWidget {
  final DocumentReference referenciaDocumento;
  const AmeacaView({Key? key, required this.referenciaDocumento})
      : super(key: key);

  @override
  State<AmeacaView> createState() => _AmeacaViewState();
}

class _AmeacaViewState extends State<AmeacaView> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final List<String> _Ameaca = [];

  @override
  void initState() {
    super.initState();
    _fetchAmeacas();
  }

  void _fetchAmeacas() async {
    try {
      final ameacas = await controllerSwot.obterAmeacas(
          reference: widget.referenciaDocumento);
      setState(() {
        _Ameaca.clear();
        _Ameaca.addAll(ameacas);
      });
      print("Ameaças carregadas: $_Ameaca");
    } catch (e) {
      print("Erro ao buscar Ameaças: $e");
    }
  }

  void _addNewAmeaca() async {
    setState(() {
      _Ameaca.add('');
    });

    // Enviar o campo vazio para o Firestore
    try {
      await controllerSwot.addAmeacas(
        reference: widget.referenciaDocumento,
        novaAmeaca: '',
      );
    } catch (e) {
      print("Erro ao adicionar Ameaça no Firestore: $e");
    }
  }

  void _updateAmeaca(int index, String newText) {
    String antigaAmeaca = _Ameaca[index];
    setState(() {
      _Ameaca[index] = newText;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        if (newText.isEmpty) {
          await controllerSwot.removerAmeacas(
            reference: widget.referenciaDocumento,
            antigaAmeaca: antigaAmeaca,
          );
          setState(() {
            _Ameaca.removeAt(index);
          });
        } else {
          // Atualizar ou adicionar a força
          await controllerSwot.updateAmeacas(
            reference: widget.referenciaDocumento,
            antigaAmeaca: antigaAmeaca,
            novaAmeaca: newText,
          );
        }
      } catch (e) {
        print("Erro ao atualizar força no Firestore: $e");
      }
    });
  }

  // Função para remover uma força no Firestore
  void _removeAmeaca(int index) async {
    String ameacaRemovida = _Ameaca[index];

    setState(() {
      _Ameaca.removeAt(index);
    });

    try {
      await controllerSwot.removerAmeacas(
        reference: widget.referenciaDocumento,
        antigaAmeaca: ameacaRemovida, // Remove do Firestore
      );
    } catch (e) {
      print("Erro ao remover ameaça no Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Altura do cabeçalho
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Espaço no topo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "T",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEEEBD9), // Fundo bege
      body: Column(
        children: [
          // Título
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ameaças',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          // Lista
          Expanded(
            child: ListView.builder(
              itemCount: _Ameaca.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_Ameaca[index]), // Chave única para o item
                  direction: DismissDirection
                      .startToEnd, // Deslizar apenas da direita para a esquerda
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    _removeAmeaca(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        title: TextFormField(
                          initialValue: _Ameaca[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite suas ameaças...',
                          ),
                          onFieldSubmitted: (value) {
                            _updateAmeaca(index, value);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botão de adicionar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _addNewAmeaca,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.transparent,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 28,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
