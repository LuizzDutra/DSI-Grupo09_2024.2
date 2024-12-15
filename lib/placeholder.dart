import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/plano_negocios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gp9/telas_plano_de_negocios.dart';

class MyPlaceholder extends StatefulWidget {
  const MyPlaceholder({super.key});

  @override
  State<MyPlaceholder> createState() => _MyPlaceholderState();
}

class _MyPlaceholderState extends State<MyPlaceholder> with RouteAware {
  late List<PlanoNegocios> dadosLocais = []; // Lista local
  final user = FirebaseAuth.instance.currentUser?.uid;
  final PageController _pageController = PageController();
  String _userInput = "";
  User? usuario = FirebaseAuth.instance.currentUser;
  int QuantidadePlanos = 0;

  late bool controle;

  Future<void> _mostrarPopup() async {
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Novo Plano"),
          content: TextField(
            controller: _controller1,
            decoration: InputDecoration(hintText: "Nome do Plano"),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o pop-up
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                try {
                  // Captura a entrada do usuário
                  String userInput = _controller1.text;
                  String? temp = usuario?.uid;

                  if (temp != null) {
                    Pessoa? pessoa =
                        await controllerPlanoNegocios.consultarPessoa(temp);

                    if (pessoa != null) {
                      int idPessoaTemp = pessoa.idPessoa;
                      PlanoNegocios novo = PlanoNegocios(
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          idPessoaTemp,
                          QuantidadePlanos + 1,
                          userInput);

                      await controllerPlanoNegocios.criarPlano(novo);
                      setState(() {
                        controle = true;
                      });
                    }
                  }

                  // Fecha o pop-up após concluir as operações
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Erro: $e");
                }
              },
            )
          ],
        );
      },
    );
  }

  Future<List<PlanoNegocios>> _obterDados() async {
    // Aguarda a chamada assíncrona

    String? temp = usuario?.uid;
    if (temp != null) {
      Pessoa? pessoa = await controllerPlanoNegocios.consultarPessoa(temp);
      if (pessoa != null) {
        int idPessoaTemp = pessoa.idPessoa;
        final dados = await controllerPlanoNegocios.getPlanos(numeroPessoa: idPessoaTemp);

        // Atualiza variáveis locais
        dadosLocais = dados;
        QuantidadePlanos = dadosLocais.length;

        if (controle) {
          setState(() {
            controle = false;
          });
        }
      }
    }

    // Retorna os dados
    return dadosLocais;
  }

  @override
  void initState() {
    super.initState();
    controllerPlanoNegocios.getPlanos(numeroPessoa: 1).then((dados) {
      setState(() {
        controle = false;
        dadosLocais = dados;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    controllerPlanoNegocios.getPlanos(numeroPessoa: 1).then((dados) {
      dadosLocais = dados;
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Plano de Negócios",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            )),
            SizedBox(
              width: 45,
            )
          ],
        ),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context,true);
            },
            color: Colors.white, // Altere para a cor que desejar
          ),
        backgroundColor: Color(0xFF001800),
        centerTitle: false,
      ),
      backgroundColor: Color(0xE5FEFEE3),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Card(
              color: Color(0xFF213E0D),
              margin: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          _mostrarPopup();
                        },
                        child: Image.asset(
                          'assets/images/circuloAdicionar.png',
                          scale: 0.9,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Plano de negócios",
                            style: TextStyle(color: Color(0xB3FFFFFF))),
                        SizedBox(height: 20),
                        Text(
                          'Nome',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 32),
                        Text(
                          "00/00/0000",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 30)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder<List<PlanoNegocios>>(
            future: _obterDados(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Erro ao carregar dados: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Nenhum plano encontrado");
              } else {
                var dados = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      var plano = dados[index];
                      return SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Dismissible(
                          key: Key(plano.idPessoa.toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) async {
                            controllerPlanoNegocios.deletarPlano(plano);
                            dados.removeAt(index);
                            setState(() {
                              controle = true;
                            });
                          },
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageView(
                                              controller: _pageController,
                                              children: [
                                                SuperTela(
                                                  primeira:
                                                      "Quem são os meus clientes?\n(Segmento de clientes)",
                                                  segunda:
                                                      "Identifique quem você quer atender: seu público-alvo. Pense nas pessoas que mais precisam do seu produto ou serviço. Quem são elas? Onde estão? O que elas valorizam?",
                                                  lista: criarListaComCard([
                                                    'Clientes',
                                                    "Valor",
                                                    "Canais",
                                                    "Relacionamentos",
                                                    "..."
                                                  ], 0),
                                                  cor: cores[0],
                                                  propriedade:
                                                      dados[index].descClientes,
                                                  name: dados[index].descNome!,
                                                  plano: dados[index],
                                                  tipo: "Clientes",
                                                ),
                                                SuperTela(
                                                    primeira:
                                                        "O que eu ofereço de especial?\n(Proposta de valor)",
                                                    segunda:
                                                        "Explique o que torna o seu produto ou serviço único e valioso para seus clientes. Por que eles escolheriam você ao invés de outra empresa?",
                                                    lista: criarListaComCard([
                                                      'Clientes',
                                                      "Valor",
                                                      "Canais",
                                                      "Relacionamentos",
                                                      "..."
                                                    ], 1),
                                                    cor: cores[1],
                                                    propriedade:
                                                        dados[index].descValor,
                                                    name:
                                                        dados[index].descNome!,
                                                    plano: dados[index],
                                                    tipo: "Valor"),
                                                SuperTela(
                                                    primeira:
                                                        "Como meus clientes vão me encontrar?\n(Canais de comunicação)",
                                                    segunda:
                                                        "Defina como você vai divulgar sua empresa e alcançar seus clientes. Será pelas redes sociais, site, loja física ou outros meios?",
                                                    lista: criarListaComCard([
                                                      'Clientes',
                                                      "Valor",
                                                      "Canais",
                                                      "Relacionamentos",
                                                      "..."
                                                    ], 2),
                                                    cor: cores[2],
                                                    propriedade:
                                                        dados[index].descCanais,
                                                    name:
                                                        dados[index].descNome!,
                                                    plano: dados[index],
                                                    tipo: "Canais"),
                                                SuperTela(
                                                    primeira:
                                                        "Como vou me relacionar com meus clientes?\n(Relacionamento com o cliente)",
                                                    segunda:
                                                        "Estabeleça como você cuidará do seu cliente antes, durante e depois da venda. Atendimento rápido, suporte, mensagens personalizadas – tudo isso conta.",
                                                    lista: criarListaComCard([
                                                      'Clientes',
                                                      "Valor",
                                                      "Canais",
                                                      "Relacionamentos",
                                                      "..."
                                                    ], 3),
                                                    cor: cores[3],
                                                    propriedade: dados[index]
                                                        .descRelacionamentos,
                                                    name:
                                                        dados[index].descNome!,
                                                    plano: dados[index],
                                                    tipo: "Relacionamentos"),
                                                SuperTela(
                                                    primeira:
                                                        "De onde virá o dinheiro?\n(Fontes de receita)",
                                                    segunda:
                                                        "Liste as maneiras pelas quais você vai ganhar dinheiro. Vai ser só pela venda do produto ou também por serviços extras, como entregas ou consultorias?",
                                                    lista: criarListaComCard([
                                                      'Receita',
                                                      "Recursos",
                                                      "Atividades",
                                                      "Parceirias",
                                                      "..."
                                                    ], 0),
                                                    cor: cores[4],
                                                    propriedade: dados[index]
                                                        .descReceita,
                                                    name:
                                                        dados[index].descNome!,
                                                    plano: dados[index],
                                                    tipo: "Receita"),
                                                SuperTela(
                                                    primeira:
                                                        " O que eu preciso para funcionar?\n(Recursos principais)",
                                                    segunda:
                                                        "Identifique os recursos mais importantes para sua operação. Podem ser equipamentos, materiais, tecnologia, ou até pessoas.",
                                                    lista: criarListaComCard([
                                                      'Receita',
                                                      "Recursos",
                                                      "Atividades",
                                                      "Parceirias",
                                                      "..."
                                                    ], 1),
                                                    cor: cores[5],
                                                    propriedade: dados[index]
                                                        .descRecursos,
                                                    name:
                                                        dados[index].descNome!,
                                                    plano: dados[index],
                                                    tipo: "Recursos"),
                                                SuperTela(
                                                    primeira:
                                                        " O que é essencial para o meu negócio?\n(Atividades-chave)",
                                                    segunda:
                                                        "Liste as tarefas mais importantes para que seu negócio funcione bem. Isso pode incluir fabricação, vendas, marketing ou entrega.",
                                                    lista: criarListaComCard([
                                                      'Receita',
                                                      "Recursos",
                                                      "Atividades",
                                                      "Parceirias",
                                                      "..."
                                                    ], 2),
                                                    name:
                                                        dados[index].descNome!,
                                                    cor: cores[6],
                                                    propriedade: dados[index]
                                                        .descAtividades,
                                                    plano: dados[index],
                                                    tipo: "Atividades"),
                                                SuperTela(
                                                    primeira:
                                                        "Com quem eu posso contar?\n(Parcerias)",
                                                    segunda:
                                                        "Pense em fornecedores, distribuidores ou até outros negócios que podem ajudar você a crescer ou reduzir custos.",
                                                    lista: criarListaComCard([
                                                      'Receita',
                                                      "Recursos",
                                                      "Atividades",
                                                      "Parceirias",
                                                      "..."
                                                    ], 3),
                                                    name:
                                                        dados[index].descNome!,
                                                    cor: cores[7],
                                                    propriedade: dados[index]
                                                        .descParcerias,
                                                    plano: dados[index],
                                                    tipo: "Parcerias"),
                                                SuperTela(
                                                    primeira:
                                                        "Quanto eu vou gastar?\n(Estrutura de custos)",
                                                    segunda:
                                                        "Descubra e organize os principais custos do seu negócio: aluguel, matéria-prima, marketing, salários, etc. Isso ajuda você a planejar melhor e evitar surpresas.",
                                                    lista: criarListaComCard([
                                                      'Custos',
                                                      "              ",
                                                      "              ",
                                                      "              ",
                                                      "              ",
                                                    ], 0),
                                                    name:
                                                        dados[index].descNome!,
                                                    cor: cores[8],
                                                    propriedade:
                                                        dados[index].descCustos,
                                                    plano: dados[index],
                                                    tipo: "Custos")
                                              ],
                                            ))).then((teste) {
                                  setState(() {
                                    controle = true;
                                  });
                                });
                              },
                              child: Card(
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Color(0xFF213E0D),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Usando um Stack para controlar a posição da imagem
                                      Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment
                                                .topRight, // Posiciona no topo centralizado
                                            child: InkWell(
                                              onTap: () {
                                                print("Helo People");
                                              },
                                              child: Image.asset(
                                                'assets/images/lixeirinha.png',
                                                width: 50,
                                                height: 25,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 15,
                                            left: 190,
                                            child: Image.asset(
                                              'assets/images/regando.png',
                                              scale: 0.9,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Plano de Negócios",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xB3FFFFFF))),
                                              SizedBox(height: 20),
                                              Text(
                                                '${plano.descNome}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 32),
                                              Text(
                                                "13/12/2024",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 30)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
