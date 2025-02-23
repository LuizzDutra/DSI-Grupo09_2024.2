import 'dart:async';

import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FraquezaView extends StatefulWidget {
  final DocumentReference referenciaDocumento;
  const FraquezaView({Key? key, required this.referenciaDocumento})
      : super(key: key);

  @override
  State<FraquezaView> createState() => _FraquezaViewState();
}

class _FraquezaViewState extends State<FraquezaView> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final List<String> _Fraqueza = [];

  @override
  void initState() {
    super.initState();
    _fetchFraquezas();
  }

  void _fetchFraquezas() async {
    try {
      final Fraquezas = await controllerSwot.obterFraquezas(
          reference: widget.referenciaDocumento);
      setState(() {
        _Fraqueza.clear();
        _Fraqueza.addAll(Fraquezas); // Adiciona as Fraquezas na lista local
      });
      print("Fraquezas carregadas: $_Fraqueza");
    } catch (e) {
      print("Erro ao buscar Fraquezas: $e");
    }
  }

  void _addNewFraqueza() async {
    setState(() {
      _Fraqueza.add('');
    });

    // Enviar o campo vazio para o Firestore
    try {
      await controllerSwot.addFraquezas(
        reference: widget.referenciaDocumento,
        novaFraqueza: '',
      );
    } catch (e) {
      print("Erro ao adicionar Fraqueza no Firestore: $e");
    }
  }

  // Função para atualizar uma força no Firestore
  void _updateFraqueza(int index, String newText) {
    String antigaFraqueza = _Fraqueza[index];
    setState(() {
      _Fraqueza[index] = newText;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        if (newText.isEmpty) {
          
          await controllerSwot.removerFraquezas(
            reference: widget.referenciaDocumento,
            antigaFraqueza: antigaFraqueza,
          );
          setState(() {
            _Fraqueza.removeAt(index);
          });
        } else {
          
          await controllerSwot.updateFraquezas(
            reference: widget.referenciaDocumento,
            antigaFraqueza: antigaFraqueza,
            novaFraqueza: newText,
          );
        }
      } catch (e) {
        print("Erro ao atualizar força no Firestore: $e");
      }
    });
  }

  // Função para remover uma força no Firestore
  void _removeFraqueza(int index) async {
    String fraquezaRemovida = _Fraqueza[index];

    setState(() {
      _Fraqueza.removeAt(index);
    });

    try {
      await controllerSwot.removerFraquezas(
        reference: widget.referenciaDocumento,
        antigaFraqueza: fraquezaRemovida, // Remove do Firestore
      );
    } catch (e) {
      print("Erro ao remover força no Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), 
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: const Color.fromARGB(255, 251, 255, 0), 
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
                    "W",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 251, 255, 0),
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
              'Fraquezas',
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
              itemCount: _Fraqueza.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_Fraqueza[index]), // Chave única para o item
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
                    _removeFraqueza(index);
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
                            color: const Color.fromARGB(255, 251, 255, 0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        title: TextFormField(
                          initialValue: _Fraqueza[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite suas fraquezas...',
                          ),
                          onFieldSubmitted: (value) {
                            _updateFraqueza(index, value);
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
                  onTap: _addNewFraqueza,
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
