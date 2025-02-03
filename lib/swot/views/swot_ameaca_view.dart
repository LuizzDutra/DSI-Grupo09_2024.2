import 'package:flutter/material.dart';

class AmeacaView extends StatefulWidget {

  const AmeacaView({Key? key}) : super(key: key);

  @override
  State<AmeacaView> createState() => _AmeacaViewState();
}

class _AmeacaViewState extends State<AmeacaView> {
  final List<String> _Ameaca = [
    '',
    '',
    '',  
  ];

  void _addNewAmeaca() {
    setState(() {
      _Ameaca.add('');
    });
  }
  void _updateAmeaca(int index, String newText) {
    setState(() {
      _Ameaca[index] = newText;
    });
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          color: const  Color.fromARGB(255, 255, 0, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      title: TextFormField(
                        initialValue: _Ameaca[index],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite suas ameaças...',
                        ),
                        onChanged: (value) {
                          _updateAmeaca(index, value);
                        },
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