import 'package:app_gp9/mapa/mapa.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/perfil/perfil_controller.dart';
import 'package:app_gp9/custom_colors.dart';
import 'package:latlong2/latlong.dart';

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
  CustomField tempo = CustomField(label: "Tempo de operação");
  CustomField funcionarios = CustomField(label: "Número de funcionários");
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
        //setState(() {});
      });
    });
  }

  IconButton saveButton() {
    return IconButton(
        iconSize: 0.05 * MediaQuery.sizeOf(context).height,
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
        iconSize: 0.05 * MediaQuery.sizeOf(context).height,
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
    return Scaffold(
        backgroundColor: customColors[6],
        body: Column(children: [
          Stack(
            children: [
              ColoredBox(
                color: customColors[7]!,
                child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 0.11 * MediaQuery.sizeOf(context).height),
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 3/100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      customButton(),
                    ],
                  ),
                ],
              )
            ],
          ),
          Expanded(
            flex: 1,
            child:  ListView(
              controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 17, right: 17, ),
              children: [
                nome,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                email,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                nomeNegocio,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                segmento,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                descricao,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                tempo,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
                funcionarios,
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.025 ),
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
  late final TextField field;

  CustomField({super.key, required this.label, this.readOnly = true, defaultText = ""}){
    controller.text = defaultText;
    field = TextField(
        enabled: !readOnly,
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(color: 
                        (){
                          if(readOnly){return Color(0XFF545454);}
                          return Color(0XFF000000);
                          }()
                        ),
        decoration: InputDecoration(
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
    return CustomField(label: label, readOnly: state, defaultText: controller.text,);
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
