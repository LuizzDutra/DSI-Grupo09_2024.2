import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gp9/empresa.dart';

class Pessoa{
  
  final String idUsuario;
  final int idPessoa;
  final String email;
  final String nome;
  Map<String,dynamic>? planos = {};
  Map<String,dynamic>? swots = {};
  String? pais;
  DateTime? _dataNascimento;
  Empresa? empresa;

  Pessoa(this.idUsuario, this.idPessoa, this.nome, this.email);

  set dataNascimento(String? dataNascimento){
    print(dataNascimento);
    if(dataNascimento != null){
      _dataNascimento = DateTime.parse(dataNascimento);
    }
  }

  String? get dataNascimento{
    if(_dataNascimento != null){ 
      _dataNascimento.toString();
    }
    return null;
  }

}

class PessoaCollection{
  
  static Future<CollectionReference<Map<String, dynamic>>?> _getPessoasCollection() async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    try {
      CollectionReference<Map<String, dynamic>> collection = await bd.collection('Pessoas');
      return collection;
    } catch (e) {
      print("Erro ao obter pessoas: $e");
    }
    return null;
  }

  static Future<Pessoa?> getPessoa(String idUsuario) async{
    var collection = await _getPessoasCollection();
    var query = await collection!.where('idUsuario', isEqualTo: idUsuario).get();
    for (var docSnapshot in query.docs) {
      Map<String, dynamic> dados = docSnapshot.data();
      return _pessoaFromJson(dados);
    }
    return null;
    
  }


  static void getPessoas() async{
    var collection = await _getPessoasCollection();
    var query = await collection!.get();
    for (var docSnapshot in query.docs) {
      Map<String, dynamic> dados = docSnapshot.data();
      print(dados);
      print(_pessoaFromJson(dados).toString());
    }
    return null;
  }

  static Future<void> transformarPessoa(Pessoa pessoa) async{
    var collection = await _getPessoasCollection();
    var query = await collection!.where('idPessoa', isEqualTo: pessoa.idPessoa).get();
    for (var docSnapshot in query.docs){
      String id = docSnapshot.reference.id;
      collection.doc(id).update(_pessoaToJson(pessoa));
    }

  }

  static _getProximoId() async{
    int id = 0;
    var collection = await _getPessoasCollection();
    var query = await collection!.orderBy('idPessoa', descending: true).limit(1).get();
    for (var docSnapshot in query.docs) {
      Map<String, dynamic> dados = docSnapshot.data();
      id = dados["idPessoa"] + 1;
    }
    return id;
  }

  static Pessoa _pessoaFromJson(Map<String, dynamic> dados){
    Pessoa pessoa = Pessoa(dados['idUsuario'], dados['idPessoa'], dados['nome'], dados['email']);
    pessoa.dataNascimento = dados['dataNascimento'];
    pessoa.pais = dados['pais'];
    pessoa.planos = dados['planos'];
    pessoa.swots = dados['swots'];

    Empresa empresa = Empresa();
    empresa.nomeNegocio = dados['empresa']['nomeNegocio'];
    empresa.numFuncionarios = dados['empresa']['numFuncionarios'];
    empresa.segmento = dados['empresa']['segmento'];
    empresa.tempoOperacao = dados['empresa']['tempoOperacao'];
    pessoa.empresa = empresa;

    return pessoa;
  }

  static Map<String, dynamic> _pessoaToJson(Pessoa pessoa){
    return <String, dynamic>{
      'idUsuario': pessoa.idUsuario,
      'idPessoa': pessoa.idPessoa,
      'email': pessoa.email,
      'nome': pessoa.nome,
      'dataNascimento': pessoa.dataNascimento,
      'pais': pessoa.pais,
      'empresa': <String, dynamic>{
        'nomeNegocio': pessoa.empresa?.nomeNegocio,
        'numFuncionarios': pessoa.empresa?.numFuncionarios,
        'segmento': pessoa.empresa?.segmento,
        'tempoOperacao': pessoa.empresa?.tempoOperacao
      },
      'planos': <String,dynamic>{
        'total': 0
      },
      'swots': <String,dynamic>{
        'total': 0
      }
      
    };
  }

  static adicionarPessoa(String idUsuario, String nome, String email) async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    Pessoa pessoa = Pessoa(idUsuario, await _getProximoId(), nome, email);
   await bd.collection("Pessoas").add(_pessoaToJson(pessoa));
  }
}