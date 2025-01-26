import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Empresa{
  String? nomeNegocio;
  String? segmento;
  int? numFuncionarios;
  int? tempoOperacaoAnos;
  LatLng? loc;
  bool show = false;

  Empresa();

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

  static Future<List<dynamic>> getEmpresas() async{
    var collection = await _getEmpresasCollection();
    QuerySnapshot<Map<String, dynamic>>? query;
    try{
      query = await collection!.where("show", isEqualTo: true).get();
    }on FirebaseException catch(e){
      print("Algo deu errado. ${e.code}: ${e.message}");
    }
    var retArray = [];
    for (var docSnapshot in query!.docs) {
      Map<String, dynamic> dados = docSnapshot.data();
      retArray.add(dados);
    }
    return retArray;
  }
}

