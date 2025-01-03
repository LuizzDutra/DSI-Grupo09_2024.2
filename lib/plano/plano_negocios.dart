import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gp9/pessoa.dart';

class PlanoNegocios {
  //Classe Entidade;

  String? _descClientes;
  String? _descValor;
  String? _descCanais;
  String? _descRelacionamentos;
  String? _descReceita;
  String? _descRecursos;
  String? _descAtividades;
  String? _descParcerias;
  String? _descCustos;
  int? _idPlano;
  int? _idPessoa;
  String? _nome;
  String? _data;

  String? get descClientes => _descClientes;
  String? get descValor => _descValor;
  String? get descCanais => _descCanais;
  String? get descRelacionamentos => _descRelacionamentos;
  String? get descReceita => _descReceita;
  String? get descRecursos => _descRecursos;
  String? get descAtividades => _descAtividades;
  String? get descParcerias => _descParcerias;
  String? get descCustos => _descCustos;
  String? get descNome => _nome;
  String? get data => _data;

  set descClientes(String? value) => _descClientes = value;
  set descValor(String? value) => _descValor = value;
  set descCanais(String? value) => _descCanais = value;
  set descRelacionamentos(String? value) => _descRelacionamentos = value;
  set descReceita(String? value) => _descReceita = value;
  set descRecursos(String? value) => _descRecursos = value;
  set descAtividades(String? value) => _descAtividades = value;
  set descParcerias(String? value) => _descParcerias = value;
  set descCustos(String? value) => _descCustos = value;
  set descNome(String? value) => _nome = value;
  set data(String? value) => _data = value;

  PlanoNegocios(
      this._descAtividades,
      this._descCanais,
      this._descClientes,
      this._descCustos,
      this._descParcerias,
      this._descReceita,
      this._descRecursos,
      this._descRelacionamentos,
      this._descValor,
      this._nome,
      this._data);

  PlanoNegocios.fromJson(Map<String, dynamic> dados) {
    _descClientes = dados['Clientes'];
    _descValor = dados['Valor'];
    _descCanais = dados['Canais'];
    _descCustos = dados['Custos'];
    _descParcerias = dados['Parcerias'];
    _descReceita = dados['Receita'];
    _descRecursos = dados['Recursos'];
    _descAtividades = dados['Atividades'];
    _descRelacionamentos = dados['Relacionamentos'];
    _nome = dados['nome'];
    _data = dados['data'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapa = {
      "Clientes": _descClientes,
      "Valor": _descValor,
      "Custos": _descCustos,
      "Parcerias": _descParcerias,
      "Receita": _descReceita,
      "Recursos": _descCustos,
      "Atividades": _descAtividades,
      "Canais": _descCanais,
      "Relacionamentos": _descRelacionamentos,
      "nome": _nome,
      "data": _data
    };

    return mapa;
  }
}

class bdPlanoNegocios {
  static final FirebaseFirestore _bd = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> getPlano({required DocumentReference reference}) async {
  var dados = await reference.get();

  if (dados.data() is Map<String, dynamic>) {
    return dados.data() as Map<String, dynamic>;
  } else {
    throw Exception('O documento não contém um Map<String, dynamic> válido');
  }
}


  static Future<void> createPlan(
      {required PlanoNegocios plano, required String idUsuario}) async {
    Map<String, dynamic> dados = plano.toJson();
    try {
      DocumentReference? reference = await _bd.collection('Planos').add(dados);
      Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
      Map<String, dynamic>? planosRef = pessoa?.planos;
      var nova_chave = planosRef?['total'] + 1;
      planosRef?[nova_chave.toString()] = reference;
      int temp = planosRef?['total'] + 1;

      await atualizarPlanos(
          idUsuario, {nova_chave.toString(): reference, 'total': temp});
    } catch (e) {
      throw Exception("Erro ao adicionar ${e}");
    }
  }

  static Future<void> updatePlan(
      {required DocumentReference reference,
      required Map<String, dynamic> dados}) async {
    try {
      await reference.update(dados);
    } catch (e) {
      throw Exception("Erro ao deletar");
    }
  }

  static Future deletePlan(
      {required DocumentReference reference, required int idPessoa}) async {
    try {
      final referencePessoa = await _bd
          .collection("Pessoa")
          .where("idPessoa", isEqualTo: idPessoa)
          .get();
      return referencePessoa.docs;
    } catch (e) {
      return null;
    }
  }

  static Future<void> atualizarPlanos(
      String idUsuario, Map<String, dynamic>? novosPlanos) async {
    try {
      final CollectionReference collection = _bd.collection('Pessoas');

      QuerySnapshot querySnapshot =
          await collection.where('idUsuario', isEqualTo: idUsuario).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documento = querySnapshot.docs.first;
        await documento.reference.update({
          'planos.${novosPlanos?['total']}':
              novosPlanos?[novosPlanos['total'].toString()],
          'planos.total': novosPlanos?['total']
        });
      }
    } catch (e) {
      print('Erro ao atualizar o campo "planos": $e');
    }
  }
}

/*class controllerPlanoNegocios {
  
  
  static getCampoPlano(PlanoNegocios plano, String target) async
  {
    return bdPlanoNegocios.getCampoPlano(idPessoa: plano.idPessoa!, idPlano: plano.idPlano!, campo: target);
  }
  

  static criarPlano(novo) {
    bdPlanoNegocios.setPlanoNegocio(plano: novo);
  }

  static editarPlano(PlanoNegocios plano, Map<String, dynamic> json) {
    int? idPessoa = plano._idPessoa;
    int? idPlano = plano.idPlano;

    bdPlanoNegocios.updatePlanoNegocio(plano._idPessoa, plano.idPlano, json);
  }

  static deletarPlano(PlanoNegocios plano) {
    bdPlanoNegocios.DeletarPlano(plano: plano);
  }

  static getPlanos({required int numeroPessoa}) {
    return bdPlanoNegocios.getPlano(idPessoa: numeroPessoa);
  }

  static consultarPessoa(String? id) async{
    return PessoaCollection.getPessoa(id!);
  }
}*/
