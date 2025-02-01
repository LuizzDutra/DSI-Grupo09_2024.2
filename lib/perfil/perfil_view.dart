import 'package:app_gp9/mapa/mapa.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/perfil/perfil_controller.dart';
import 'package:app_gp9/custom_colors.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilState();
}

class _PerfilState extends State<PerfilView> {
  CustomField nome = CustomField(label:"Nome", maxSize: null,);
  CustomField email = CustomField(label:"Email", readOnly: true, maxSize: null,);
  CustomField nomeNegocio = CustomField(label:"Nome do Negócio", maxSize: 30);
  CustomField segmento = CustomField(label:"Segmento do Negócio");
  CustomField descricao = CustomField(label:"Breve Descrição do negócio", inputType: TextInputType.multiline, maxSize: 500,);
  CustomField tempo = CustomField(label: "Tempo de operação em anos", inputType: TextInputType.number, maxSize: null,);
  CustomField funcionarios = CustomField(label: "Número de funcionários", inputType: TextInputType.number, maxSize: null,);
  bool editState = false;
  bool show = false;
  ScrollController scrollController = ScrollController();

  Mapa mapa = Mapa(noMarker: true, disabled: true, defaultZoom: 16);


  @override
  void initState() {
    super.initState();
    PerfilController.getPessoaLogada().then((pessoa) {
      nome.controller.text = pessoa.nome;
      email.controller.text = pessoa.email;
      PerfilController.getEmpresa(pessoa.empresa!).then((empresa) async{
        nomeNegocio.controller.text = empresa.nomeNegocio;
        segmento.controller.text = empresa.segmento;
        descricao.controller.text = empresa.descricao;
        tempo.controller.text = empresa.tempoOperacaoAnos.toString();
        funcionarios.controller.text = empresa.numFuncionarios.toString();
        show = empresa.show;
        if(empresa.loc != LatLng(0, 0)){
          mapa.defaultCenter = empresa.loc;
        }
        setState(() {});
      });
    });
  }

  IconButton saveButton() {
    return IconButton(
        icon: Icon(Icons.save),
        color: Colors.white,
        onPressed: () {
          setState(() {
            PerfilController.saveData(
                nome.controller.text,
                nomeNegocio.controller.text,
                segmento.controller.text,
                descricao.controller.text,
                int.parse(tempo.controller.text),
                int.parse(funcionarios.controller.text),
                show,
                (){if(show){return mapa.getMapCenter();}return LatLng(0, 0);}());
            nome = nome.setReadOnly(true);
            nomeNegocio = nomeNegocio.setReadOnly(true);
            segmento = segmento.setReadOnly(true);
            descricao = descricao.setReadOnly(true);
            tempo = tempo.setReadOnly(true);
            funcionarios = funcionarios.setReadOnly(true);
            mapa.disabled = true;
            editState = false;
          });
        });
  }

  IconButton editButton(){
    return IconButton(
        icon: Icon(Icons.edit),
        color: Colors.white,
        onPressed: () async{
          if(mapa.defaultCenter == LatLng(0, 0)){
          LatLng? userLoc = await PerfilController.getUserLoc();
          if(userLoc != null){
            mapa.defaultCenter = userLoc;
          }else{
            mapa.defaultZoom = 3;
          }
          }
          setState(() {
            nome = nome.setReadOnly(false);
            nomeNegocio = nomeNegocio.setReadOnly(false);
            segmento = segmento.setReadOnly(false);
            descricao = descricao.setReadOnly(false);
            tempo = tempo.setReadOnly(false);
            funcionarios = funcionarios.setReadOnly(false);
            mapa.disabled = false;
            editState = true;
          });
        });
  }

  IconButton customButton(){
    if(editState){
      return saveButton();
    }
    return editButton();
  }

  Function(bool)? switchFunc(value){
    if(editState){
      return (value){
        setState(() {
          show = value;
          if(show){
            scrollController.animateTo(scrollController.position.extentTotal, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          }else{
            scrollController.animateTo(scrollController.position.minScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.linear);
          }
        });
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizedBox fieldSpacer = SizedBox(height: MediaQuery.sizeOf(context).height * 0.015 );
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
          backgroundColor: customColors[7],
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(size: 35, color: Colors.white),
          actionsIconTheme: IconThemeData(size: 45),
          actions: [
            customButton()
          ],
        ),
        backgroundColor: customColors[6],
        body: Column(children: [
          Expanded(
            flex: 1,
            child:  ListView(
              controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 17, right: 17, ),
              children: [
                nome,
                fieldSpacer,
                email,
                fieldSpacer,
                nomeNegocio,
                fieldSpacer,
                segmento,
                fieldSpacer,
                descricao,
                fieldSpacer,
                tempo,
                fieldSpacer,
                funcionarios,
                fieldSpacer,
                Row(children: [
                  Text("Mostrar sua empresa \npara outros usuários ", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  Switch(activeColor: customColors[7], value: show, onChanged: switchFunc(show))
                  ]),
                if(show) SizedBox(
                  height: MediaQuery.sizeOf(context).width,
                  width: MediaQuery.sizeOf(context).width,
                child: Stack(alignment: AlignmentDirectional(0, -0.1),children: [
                  mapa.getMapBuilder(true),
                  IgnorePointer(child:Image(image: AssetImage("assets/images/Logo.png"), alignment: Alignment(0.5, 0)))
                  ])),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
              ],
            ),)
         
        ]));
  }
}

class CustomField extends StatelessWidget{
  final String label;
  final TextEditingController controller = TextEditingController();
  final bool readOnly;
  final TextInputType inputType;
  final int? maxSize;
  late final TextField field;

  CustomField(
      {super.key,
      required this.label,
      this.readOnly = true,
      this.inputType = TextInputType.text,
      this.maxSize = 30,
      defaultText = ""}) {
    controller.text = defaultText;
    String? counterText = null;
    if(maxSize == null){
      counterText = " ";
    }
    field = TextField(
        enabled: !readOnly,
        controller: controller,
        readOnly: readOnly,
        keyboardType: inputType,
        maxLines: null,
        maxLength: maxSize,
        style: TextStyle(color: 
                        (){
                          if(readOnly){return Color(0XFF545454);}
                          return Color(0XFF000000);
                          }()
                        ),
        decoration: InputDecoration(
          counterText: counterText,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width:1, color:Color(0XFF000000))
                ),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width:1, color:Color(0XFF999999))
                ),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width:2, color:customColors[7]!)
                )
    ));
  }

  CustomField setReadOnly(bool state){
    return CustomField(label: label, readOnly: state, inputType: inputType, defaultText: controller.text, maxSize: maxSize,);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        field
      ],
    );
  }
}
