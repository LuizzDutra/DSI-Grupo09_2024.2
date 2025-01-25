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
      CollectionReference<Map<String, dynamic>> collection = await bd.collection('Empresas');
      return collection;
    } catch (e) {
      print("Erro ao obter empresas: $e");
    }
    return null;
  }

  static Future<List<dynamic>> getEmpresas() async{
    var collection = await _getEmpresasCollection();
    var query = await collection!.where("show", isEqualTo: true).get();
    var retArray = [];
    for (var docSnapshot in query.docs) {
      Map<String, dynamic> dados = docSnapshot.data();
      retArray.add(dados);
    }
    return retArray;
  }
}

