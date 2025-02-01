import 'package:app_gp9/autenticacao.dart';
import 'package:app_gp9/home_page/home_view.dart';
import 'package:app_gp9/plano/planos_view_temp.dart';
import 'package:flutter/material.dart';

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
  }

  MaterialPageRoute rotaStartPage = MaterialPageRoute(
      builder: (context) => PageView(
            children: [
              //const Page1(),
              //const Page2(),
              //const Page3(),
              MyPlaceholder(),
              //PlanoCreate()
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageView(
              children: [
                Home(),
              ],
            ),
          ),
        );
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:MediaQuery.sizeOf(context).height*0.1),
              Center(
                  child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.sizeOf(context).height * 0.18,
                      height: MediaQuery.sizeOf(context).height * 0.18,
                      child: const Image(
                        image: AssetImage('assets/images/Logo_Login.png'),
                        fit: BoxFit.fitHeight,
                      )),
                  const Text(
                    "Perene",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
                  const Text(
                    "Efetue seu login",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0XFF6C6C6C),
                        fontWeight: FontWeight.w500),
                  )
                ],
                  )),
              SizedBox(height:MediaQuery.sizeOf(context).height*0.05),
              SizedBox(
                width: MediaQuery.sizeOf(context).width*0.75,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.025,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width*0.75,
                child: TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () async {
                        realizarLogin();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0XFF628B27)),
                        fixedSize: WidgetStatePropertyAll(Size(MediaQuery.sizeOf(context).width*0.85,  MediaQuery.sizeOf(context).height * 0.06)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins"
                        ),
                      )),
                  SizedBox(
                    height:  MediaQuery.sizeOf(context).height * 0.03,
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
                            WidgetStatePropertyAll(Color(0xFFFEFEE3)),
                      ),
                      child: const Text(
                        "Criar uma conta",
                        style: TextStyle(
                          color: Color(0xFF098691),
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
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                color: Color(0xFF001800)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Efetue seu cadastro",
            style: TextStyle(color: Color(0xFF6C6C6C), fontSize: 20),
          ),
        ],
      ),
    );
  }

  dynamic getFields() {
    const TextStyle style = TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001800),
            );
    double width = MediaQuery.sizeOf(context).width*0.75;
    return Wrap(direction: Axis.vertical, spacing: 20.0, alignment: WrapAlignment.center, children: [
      SizedBox(
        width: width,
        child: TextField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome completo',
            labelStyle: style
          ),
        ),
      ),
      SizedBox(
        width: width,
        child: TextField(
          obscureText: false,
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            labelStyle: style
          ),
        ),
      ),
      SizedBox(
        width: width,
        child: TextField(
          obscureText: true,
          controller: _senhaController,
          decoration: const InputDecoration(
            labelText: 'Criar Senha',
            labelStyle: style
          ),
        ),
      ),
      SizedBox(
        width: width,
        child: TextField(
          obscureText: true,
          controller: _senhaConfController,
          decoration: const InputDecoration(
            labelText: 'Confimar senha',
            labelStyle: style
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
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF628b27)),
              fixedSize: WidgetStatePropertyAll(Size(MediaQuery.sizeOf(context).width*0.85,  MediaQuery.sizeOf(context).height * 0.06)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
            ),
            child: const Text(
              "Cadastrar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEFEE3),
        iconTheme: IconThemeData(size: 35),
      ),
      backgroundColor: const Color(0xFFFEFEE3),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: height*0.030,),
              getHeader(),
              SizedBox(height: height*0.05,),
              getFields(),
              SizedBox(height: height*0.25,),
              getButtons(),
            ],
          )),
    );
  }
}
