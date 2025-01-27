import 'package:flutter/material.dart';
import 'package:app_gp9/perfil/perfil_controller.dart';
import 'package:app_gp9/custom_colors.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilState();
}

class _PerfilState extends State<PerfilView> {
  CustomField nome = CustomField(label:"Nome", readOnly: false,);
  CustomField email = CustomField(label:"Email", readOnly: true,);


  @override
  void initState() {
    super.initState();
    PerfilController.getPessoaLogada().then((pessoa) {
      nome.controller.text = pessoa.nome;
      email.controller.text = pessoa.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      ColoredBox(
        color: customColors[7]!,
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 0.11 * MediaQuery.sizeOf(context).height),
      ),
      ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 17),
        children: [
          nome,
          email,
          ElevatedButton(onPressed: (){
            setState(() {
              nome = CustomField(label: "Nome", readOnly: !nome.field.readOnly, defaultText: nome.controller.text,);
            });
            print("Aqui");
          }, child: Text("Aqui"))
        ],
      ),
    ]));
  }
}

class CustomField extends StatelessWidget{
  final String label;
  final TextEditingController controller = TextEditingController();
  late final TextField field;

  CustomField({super.key, required this.label, required bool readOnly, defaultText = ""}){
    controller.text = defaultText;
    field = TextField(controller: controller,readOnly: readOnly,);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black, width: 1)),
          child: field
        )
      ],
    );
  }
}
