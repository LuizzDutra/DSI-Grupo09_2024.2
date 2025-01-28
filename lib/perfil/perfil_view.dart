import 'package:flutter/material.dart';
import 'package:app_gp9/perfil/perfil_controller.dart';
import 'package:app_gp9/custom_colors.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilState();
}

class _PerfilState extends State<PerfilView> {
  CustomField nome = CustomField(label:"Nome");
  CustomField email = CustomField(label:"Email", readOnly: true,);
  CustomField nomeNegocio = CustomField(label:"Nome do Negócio");
  CustomField segmento = CustomField(label:"Segmento do Negócio");
  CustomField descricao = CustomField(label:"Breve Descrição do negócio");


  @override
  void initState() {
    super.initState();
    PerfilController.getPessoaLogada().then((pessoa) {
      nome.controller.text = pessoa.nome;
      email.controller.text = pessoa.email;
      PerfilController.getEmpresa(pessoa.empresa!).then((empresa){
        nomeNegocio.controller.text = empresa.nomeNegocio;
        segmento.controller.text = empresa.segmento;
        descricao.controller.text = empresa.descricao;
      });
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
          nomeNegocio,
          segmento,
          descricao,
          ElevatedButton(onPressed: (){
            setState(() {
              PerfilController.saveData(nome.controller.text, nomeNegocio.controller.text, segmento.controller.text, descricao.controller.text);
            });
          }, child: Text("Aqui"))
        ],
      ),
    ]));
  }
}

class CustomField extends StatelessWidget{
  final String label;
  final TextEditingController controller = TextEditingController();
  final bool readOnly;
  late final TextField field;

  CustomField({super.key, required this.label, this.readOnly = false, defaultText = ""}){
    controller.text = defaultText;
    field = TextField(controller: controller,readOnly: readOnly,);
  }

  CustomField setReadOnly(bool state){
    return CustomField(label: label, readOnly: state, defaultText: controller.text,);
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
