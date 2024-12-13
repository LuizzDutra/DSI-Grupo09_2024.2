import 'package:app_gp9/pages_intro.dart';
import 'package:app_gp9/autenticacao.dart';
import 'package:app_gp9/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/pessoa.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PessoaCollection.getPessoas();
  }

  MaterialPageRoute rotaStartPage = MaterialPageRoute(
      builder: (context) => PageView(
            children: [
              const Page1(),
              const Page2(),
              const Page3(),
              MyPlaceholder()
            ],
          ));

  void realizarLogin() async {
    try {
      if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
        throw "Preencha todos os campos";
      }
      await ControladorAutenticar.logar(
          _emailController.text, _senhaController.text);
      if (context.mounted) {
        Navigator.push(context, rotaStartPage);
      }
    } on String catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(e),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEE3),
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      "Seja Bem-Vindo",
                      style: TextStyle(
                          color: Color(0xFF001800),
                          fontSize: 40,
                          fontFamily: "Megrim",
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Efetue seu login",
                      style: TextStyle(
                          color: Color(0xFF8EA4A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () async {
                        realizarLogin();
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF628b27)),
                        fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registro()));
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF001800)),
                        fixedSize: WidgetStatePropertyAll(Size(188, 45)),
                      ),
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(
                          color: Color(0xFFFFDE59),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),

              /*
              const SizedBox(height: 10,),
              const Text("Esqueceu a senha?"),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){}, child: const Text("Clique aqui",style: TextStyle(color: Color.fromRGBO(54, 9, 234, 1)),),)*/
            ],
          )),
    );
  }
}

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _senhaConfController = TextEditingController();

  Future<void> registrar() async {
    //To-do
    if (_senhaController.text != _senhaConfController.text) {
      throw "As senhas estão diferentes";
    }
    if (_emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _senhaConfController.text.isEmpty ||
        _nomeController.text.isEmpty) {
      throw "Preencha todos os campos";
    }

    await ControladorAutenticar.registrar(
        _emailController.text, _senhaController.text, _nomeController.text);
  }

  dynamic getHeader() {
    return const Center(
      child: Column(
        children: [
          Text(
            "Cadastro",
            style: TextStyle(
                fontSize: 40,
                fontFamily: "Megrim",
                fontWeight: FontWeight.w900,
                color: Color(0xFF001800)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Efetue seu cadastro",
            style: TextStyle(color: Color(0xFF8EA4A4), fontSize: 20),
          ),
        ],
      ),
    );
  }

  dynamic getFields() {
    return Wrap(spacing: 20.0, children: [
      SizedBox(
        width: 320,
        child: TextField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome completo',
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001800),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 320,
        child: TextField(
          obscureText: false,
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001800),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 320,
        child: TextField(
          obscureText: true,
          controller: _senhaController,
          decoration: const InputDecoration(
            labelText: 'Criar Senha',
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001800),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 320,
        child: TextField(
          obscureText: true,
          controller: _senhaConfController,
          decoration: const InputDecoration(
            labelText: 'Confimar senha',
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001800),
            ),
          ),
        ),
      ),
    ]);
  }

  dynamic getButtons() {
    return Column(
      children: [
        FilledButton(
            onPressed: () async {
              try {
                await registrar();
                if (mounted) Navigator.pop(context);
              } on String catch (e) {
                if (mounted) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(e),
                        );
                      });
                }
              }
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF628b27)),
              fixedSize: WidgetStatePropertyAll(Size(188, 45)),
            ),
            child: const Text(
              "Cadastrar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        FilledButton(
            onPressed: () => Navigator.pop(context),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF001800)),
              fixedSize: WidgetStatePropertyAll(Size(188, 45)),
            ),
            child: const Text(
              "Voltar",
              style: TextStyle(
                color: Color(0xFFFFDE59),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEE3),
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              getHeader(),
              const Spacer(flex: 50),
              getFields(),
              const Spacer(flex: 20),
              getButtons(),
              const Spacer(flex: 200),
            ],
          )),
    );
  }
}
