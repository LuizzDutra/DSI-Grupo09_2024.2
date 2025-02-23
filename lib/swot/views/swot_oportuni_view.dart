import 'dart:async';
import 'package:app_gp9/swot/Controller/swot_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OportuniView extends StatefulWidget {
  final DocumentReference referenciaDocumento;
  const OportuniView({Key? key, required this.referenciaDocumento})
      : super(key: key);

  @override
  State<OportuniView> createState() => _OportuniViewState();
}

class _OportuniViewState extends State<OportuniView> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final List<String> _Oportunidade = [];

  @override
  void initState() {
    super.initState();
    _fetchOportunidades();
  }

  void _fetchOportunidades() async {
    try {
      final Oportunidades = await controllerSwot.obterOportunidades(
          reference: widget.referenciaDocumento);
      setState(() {
        _Oportunidade.clear();
        _Oportunidade.addAll(Oportunidades);
      });
      print("Oportunidades carregadas: $_Oportunidade");
    } catch (e) {
      print("Erro ao buscar Oportunidades: $e");
    }
  }

  void _addNewOportunidade() async {
    setState(() {
      _Oportunidade.add('');
    });

    // Enviar o campo vazio para o Firestore
    try {
      await controllerSwot.addOporrtunidades(
        reference: widget.referenciaDocumento,
        novaOportunidade: '',
      );
    } catch (e) {
      print("Erro ao adicionar Oportunidade no Firestore: $e");
    }
  }

  void _updateOportunidade(int index, String newText) {
    String antigaOportunidade = _Oportunidade[index];
    setState(() {
      _Oportunidade[index] = newText;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        if (newText.isEmpty) {
          await controllerSwot.removerOportunidades(
            reference: widget.referenciaDocumento,
            antigaOportunidade: antigaOportunidade,
          );
          setState(() {
            _Oportunidade.removeAt(index);
          });
        } else {
          // Atualizar ou adicionar a força
          await controllerSwot.updateOportunidades(
            reference: widget.referenciaDocumento,
            antigaOportunidade: antigaOportunidade,
            novaOportunidade: newText,
          );
        }
      } catch (e) {
        print("Erro ao atualizar força no Firestore: $e");
      }
    });
  }

  // Função para remover uma força no Firestore
  void _removeOportunidade(int index) async {
    String oportunidadeRemovida = _Oportunidade[index];

    setState(() {
      _Oportunidade.removeAt(index);
    });

    try {
      await controllerSwot.removerOportunidades(
        reference: widget.referenciaDocumento,
        antigaOportunidade: oportunidadeRemovida, // Remove do Firestore
      );
    } catch (e) {
      print("Erro ao remover oportunidade no Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Altura do cabeçalho
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: const Color.fromARGB(255, 0, 102, 255), // Fundo roxo
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
                    "O",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 89, 255),
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
              'Oportunidades',
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
              itemCount: _Oportunidade.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_Oportunidade[index]), // Chave única para o item
                  direction: DismissDirection.startToEnd, //
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
                    _removeOportunidade(index);
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
                            color: const Color.fromARGB(255, 0, 89, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        title: TextFormField(
                          initialValue: _Oportunidade[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite suas fraquezas...',
                          ),
                          onFieldSubmitted: (value) {
                            _updateOportunidade(index, value);
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
                  onTap: _addNewOportunidade,
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
