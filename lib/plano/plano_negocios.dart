import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gp9/pessoa.dart';

class PlanoNegocios {
  // Classe Entidade

  Map<String, dynamic>? _descClientes;
  Map<String, dynamic>? _descValor;
  Map<String, dynamic>? _descCanais;
  Map<String, dynamic>? _descRelacionamentos;
  Map<String, dynamic>? _descReceita;
  Map<String, dynamic>? _descRecursos;
  Map<String, dynamic>? _descAtividades;
  Map<String, dynamic>? _descParcerias;
  Map<String, dynamic>? _descCustos;
  String? _nome;
  int? _idPessoa;
  DocumentReference? _referencia;

  Map<String, dynamic>? get descClientes => _descClientes;
  Map<String, dynamic>? get descValor => _descValor;
  Map<String, dynamic>? get descCanais => _descCanais;
  Map<String, dynamic>? get descRelacionamentos => _descRelacionamentos;
  Map<String, dynamic>? get descReceita => _descReceita;
  Map<String, dynamic>? get descRecursos => _descRecursos;
  Map<String, dynamic>? get descAtividades => _descAtividades;
  Map<String, dynamic>? get descParcerias => _descParcerias;
  Map<String, dynamic>? get descCustos => _descCustos;
  String? get descNome => _nome;
  int? get idPessoa => _idPessoa;
  DocumentReference? get referencia => _referencia;

  set descClientes(Map<String, dynamic>? value) => _descClientes = value;
  set descValor(Map<String, dynamic>? value) => _descValor = value;
  set descCanais(Map<String, dynamic>? value) => _descCanais = value;
  set descRelacionamentos(Map<String, dynamic>? value) => _descRelacionamentos = value;
  set descReceita(Map<String, dynamic>? value) => _descReceita = value;
  set descRecursos(Map<String, dynamic>? value) => _descRecursos = value;
  set descAtividades(Map<String, dynamic>? value) => _descAtividades = value;
  set descParcerias(Map<String, dynamic>? value) => _descParcerias = value;
  set descCustos(Map<String, dynamic>? value) => _descCustos = value;
  set descNome(String? value) => _nome = value;
  set idPessoa(int? value) => _idPessoa = value;


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
      this._nome,);

  Map<String, dynamic> toJson() {
    return {
      'descAtividades': _descAtividades,
      'descCanais': _descCanais,
      'descClientes': _descClientes,
      'descCustos': _descCustos,
      'descParcerias': _descParcerias,
      'descReceita': _descReceita,
      'descRecursos': _descRecursos,
      'descRelacionamentos': _descRelacionamentos,
      'descValor': _descValor,
      'nome': _nome,
      "referencia": _referencia
    };
  }

  PlanoNegocios.fromJson(Map<String, dynamic> dados) {
    _descClientes = dados['Clientes'];//
    _descValor = dados['Proposta de valor'];//
    _descCanais = dados['Canais'];//
    _descCustos = dados['Custos'];//
    _descParcerias = dados['Parcerias'];//
    _descReceita = dados['Receita'];//
    _descRecursos = dados['Recursos'];//
    _descAtividades = dados['Atividades'];//
    _descRelacionamentos = dados['Relacionamento'];//
    _nome = dados['nome'];//
    _referencia = dados['referencia'];//
  }
  
}


class bdPlanoNegocios {
  static final FirebaseFirestore _bd = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> getPlano({required DocumentReference? reference}) async {
  var dados = await reference!.get();
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
      DocumentReference? referencia = await _bd.collection('Planos').add(dados);
      await updatePlan(reference: referencia, dados: {'referencia': referencia});
      Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
      Map<String, dynamic>? planosRef = pessoa?.planos;
      var nova_chave = planosRef?['total'] + 1;
      planosRef?[nova_chave.toString()] = referencia;
      int temp = planosRef?['total'] + 1;

      await atualizarPlanos(
          idUsuario, {nova_chave.toString(): referencia, 'total': temp});
    } catch (e) {
      throw Exception("Erro ao adicionar ${e}");
    }
  }

  static Future<void> updatePlan(
      {required DocumentReference? reference,
      required Map<String, dynamic> dados}) async {
    try {
      await reference!.update(dados);
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
