import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Empresa{
  String nomeNegocio;
  String segmento;
  int numFuncionarios;
  int tempoOperacaoAnos;
  LatLng loc = LatLng(0, 0);
  bool show = false;

  Empresa(this.nomeNegocio, this.segmento, this.numFuncionarios, this.tempoOperacaoAnos);

}


class EmpresaCollection{
  
  static Future<CollectionReference<Map<String, dynamic>>?> _getEmpresasCollection() async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    try {
      CollectionReference<Map<String, dynamic>> collection = bd.collection('Empresas');
      return collection;
    } on FirebaseException catch (e) {
      print("Erro ao obter empresas: ${e.message}");
    }
    return null;
  }

  static Future<List<Empresa>> getEmpresas() async{
    var collection = await _getEmpresasCollection();
    QuerySnapshot<Map<String, dynamic>>? query;
    try{
      query = await collection!.where("show", isEqualTo: true).get();
    }on FirebaseException catch(e){
      print("Algo deu errado. ${e.code}: ${e.message}");
    }
    List<Empresa> retArray = [];
    for (var docSnapshot in query!.docs) {
      Empresa empresa = _empresaFromJson(docSnapshot.data());
      retArray.add(empresa);
    }
    return retArray;
  }

  static Future<Empresa> getEmpresaByReference(String reference) async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    DocumentSnapshot doc = await bd.doc(reference).get();
    var data = doc.data() as Map<String, dynamic>;
    return _empresaFromJson(data);
  }

  static Future<DocumentReference<Map<String, dynamic>>> addEmpresa(Empresa empresa) async{
    CollectionReference<Map<String, dynamic>>? collectionEmpresa = await _getEmpresasCollection();
    return await collectionEmpresa!.add(_empresaToJson(empresa));
  }

  static void updateEmpresa(String reference, Map<String, dynamic> data) async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    DocumentReference docRef = bd.doc(reference);
    await docRef.update(data);
  }

  static Empresa _empresaFromJson(Map<String, dynamic> dados){
    Empresa empresa = Empresa(dados["nomeNegocio"], dados["segmento"], dados["numFuncionarios"], dados["tempoOperacaoAnos"]);
    empresa.loc = LatLng(dados["loc"].latitude, dados["loc"].longitude);
    empresa.show = dados["show"];
    return empresa;
  }

  static Map<String, dynamic> _empresaToJson(Empresa empresa){
    Map<String, dynamic> dados = {
      "nomeNegocio": empresa.nomeNegocio,
      "segmento": empresa.segmento,
      "numFuncionarios": empresa.numFuncionarios,
      "tempoOperacaoAnos": empresa.tempoOperacaoAnos,
      "loc": GeoPoint(empresa.loc.latitude, empresa.loc.longitude),
      "show": empresa.show,

    };
    return dados;
  }

}

