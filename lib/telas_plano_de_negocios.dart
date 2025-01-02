import 'package:app_gp9/plano_negocios.dart';
import 'package:flutter/material.dart';

class SuperTela extends StatefulWidget {
  final String primeira;
  final String segunda;
  final List<Widget> lista;
  final Color cor;
  //final int idPessoa;
  //final int idPlano;
  final String? propriedade;
  final String name;
  final PlanoNegocios plano;
  final String tipo;

  const SuperTela(
      {super.key,
      required this.primeira,
      required this.segunda,
      required this.lista,
      required this.cor,
      required this.propriedade,required this.name, required this.plano, required this.tipo});

  @override
  State<SuperTela> createState() => _SuperTela();
}

class _SuperTela extends State<SuperTela> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  late String novo;

  

  @override
  void initState() {
    controllerPlanoNegocios.getCampoPlano(widget.plano,widget.tipo).then((resultado){
      _controller.text = resultado!;
    });
    print("Fui chamado");
    novo = _controller.text;
    super.initState();
  }

  



  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if(novo != _controller.text){
          controllerPlanoNegocios.editarPlano(widget.plano, {widget.tipo:_controller.text});
          novo = _controller.text;
          
        }
        
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF001800),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context,true);
            },
            color: Colors.white, // Altere para a cor que desejar
          ),
        ),
        backgroundColor: Color(0xFFFEFEE3),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF82B135),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.lista),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.9, top: 39),
                    child: Row(
                      children: [
                        Text(
                          widget.primeira,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.9, top: 16, right: 24),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(widget.segunda,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xFF393939))))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 230,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    child: Card(
                      color: widget.cor,
                      elevation: 5,
                      margin: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              hintText: "Clique para escrever",
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(fontStyle: FontStyle.italic)),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> criarListaComCard(List<String> strings, int posicao) {
  return List<Widget>.generate(strings.length, (index) {
    if (index == posicao) {
      return Card(
        color: Color(0xFF82B135),
        child: Text(strings[index]),
      );
    } else {
      return Text(strings[index]);
    }
  });
}

List<Color> cores = [
  Color(0xFFBFDC76), // 1
  Color(0xFF76BBDC), // 2
  Color(0xFFDC76C9), // 3
  Color(0xFFDC7676), // 4
  Color(0xFF9676DC), // 5
  Color(0xFFDCC776), // 6
  Color(0xFFBFDC76), // 7
  Color(0xFF76BBDC), // 8
  Color(0xFFDC76C9), // 9
];
