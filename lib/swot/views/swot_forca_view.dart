import 'dart:async';
import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ForcaView extends StatefulWidget {
  final DocumentReference referenciaDocumento;

  const ForcaView({Key? key, required this.referenciaDocumento})
      : super(key: key);

  @override
  State<ForcaView> createState() => _ForcaViewState();
}

class _ForcaViewState extends State<ForcaView> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final List<String> _Forca = [];

  @override
  void initState() {
    super.initState();
    _fetchForcas();
  }

  void _fetchForcas() async {
    try {
      final forcas = await controllerSwot.obterForcas(
          reference: widget.referenciaDocumento);
      setState(() {
        _Forca.clear();
        _Forca.addAll(forcas); // Adiciona as forças na lista local
      });
      print(
          "Forças carregadas: $_Forca"); 
    } catch (e) {
      print("Erro ao buscar forças: $e");
    }
  }

  void _addNewForca() async {
    setState(() {
      _Forca.add('');
    });

    // Enviar o campo vazio para o Firestore
    try {
      await controllerSwot.addForca(
        reference: widget.referenciaDocumento,
        novaForca: '',
      );
    } catch (e) {
      print("Erro ao adicionar força no Firestore: $e");
    }
  }

  // Função para atualizar uma força no Firestore
  void _updateForca(int index, String newText) {
    String antigaForca = _Forca[index];
    setState(() {
      _Forca[index] = newText;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        if (newText.isEmpty) {
          // Remover a força vazia do Firestore
          await controllerSwot.removerForca(
            reference: widget.referenciaDocumento,
            antigaForca: antigaForca,
          );
          setState(() {
            _Forca.removeAt(index);
          });
        } else {
          // Atualizar ou adicionar a força
          await controllerSwot.updateForca(
            reference: widget.referenciaDocumento,
            antigaForca: antigaForca,
            novaForca: newText,
          );
        }
      } catch (e) {
        print("Erro ao atualizar força no Firestore: $e");
      }
    });
  }

  // Função para remover uma força no Firestore
  void _removeForca(int index) async {
  String forcaRemovida = _Forca[index]; 

  setState(() {
    _Forca.removeAt(index);
  });

  try {
    await controllerSwot.removerForca(
      reference: widget.referenciaDocumento,
      antigaForca: forcaRemovida, // Remove do Firestore
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
          backgroundColor: const Color.fromARGB(255, 255, 0, 255),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "S",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 0, 255),
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
              'Forças',
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
              itemCount: _Forca.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_Forca[index]), // Chave única para o item
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
                    _removeForca(index);
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
                            color: const Color.fromARGB(255, 255, 0, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        title: TextFormField(
                          initialValue: _Forca[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite suas forças...',
                          ),
                          onFieldSubmitted: (value) {
                            _updateForca(index, value);
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
                  onTap: _addNewForca,
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
