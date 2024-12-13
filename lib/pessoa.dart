import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gp9/empresa.dart';

class Pessoa{
  
  final String idUsuario;
  final int idPessoa;
  final String email;
  final String nome;
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
  
  static _getPessoasDocument() async{
    FirebaseFirestore bd = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot =
          await bd.collection('Pessoas').get();

      return querySnapshot.docs;
    } catch (e) {
      print("Erro ao obter pessoas: $e");
    }
  }

  static Future<Pessoa?> getPessoa(String idUsuario) async{
    var docs = await _getPessoasDocument();
    docs.forEach((docSnapshot){
      Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;
      if(dados["idUsuario"] == idUsuario){
        return _pessoaFromJson(dados);
      }
    });
    return null;
    
  }

  static void getPessoas() async{
    var docs = await _getPessoasDocument();
    docs.forEach((docSnapshot){
      Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;
        print(dados);
        print(_pessoaFromJson(dados).toString());
    });
  }

  static _getProximoId() async{
    int id = 0;
    var docs = await _getPessoasDocument();
    docs.forEach((docSnapshot){
      Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;
      if(dados["idPessoa"] >= id){
        id = dados["idPessoa"];
      }
    });
    return id+1;
  }

  static Pessoa _pessoaFromJson(Map<String, dynamic> dados){
    Pessoa pessoa = Pessoa(dados['idUsuario'], dados['idPessoa'], dados['nome'], dados['email']);
    pessoa.dataNascimento = dados['dataNascimento'];
    pessoa.pais = dados['pais'];

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
      }
    };
  }

  static adicionarPessoa(String idUsuario, String nome, String email) async{
    FirebaseFirestore _bd = FirebaseFirestore.instance;
    Pessoa pessoa = Pessoa(idUsuario, await _getProximoId(), nome, email);
   await _bd.collection("Pessoas").add(_pessoaToJson(pessoa));

  }
}