import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

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

  String? get descClientes => _descClientes;
  String? get descValor => _descValor;
  String? get descCanais => _descCanais;
  String? get descRelacionamentos => _descRelacionamentos;
  String? get descReceita => _descReceita;
  String? get descRecursos => _descRecursos;
  String? get descAtividades => _descAtividades;
  String? get descParcerias => _descParcerias;
  String? get descCustos => _descCustos;
  int? get idPlano => _idPlano;
  int? get idPessoa => _idPessoa;

  set descClientes(String? value) => _descClientes = value;
  set descValor(String? value) => _descValor = value;
  set descCanais(String? value) => _descCanais = value;
  set descRelacionamentos(String? value) => _descRelacionamentos = value;
  set descReceita(String? value) => _descReceita = value;
  set descRecursos(String? value) => _descRecursos = value;
  set descAtividades(String? value) => _descAtividades = value;
  set descParcerias(String? value) => _descParcerias = value;
  set descCustos(String? value) => _descCustos = value;
  set idPlano(int? value) => _idPlano = value;
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
    this._idPessoa,
    this._idPlano,
  );

  PlanoNegocios.fromJson(Map<String, dynamic> dados) {
    _descClientes = dados['Clientes'];
    _descValor = dados['Valor'];
    _descCanais = dados['Canais'];
    _descCustos = dados['Custo'];
    _descParcerias = dados['Parcerias'];
    _descReceita = dados['Receita'];
    _descRecursos = dados['Recursos'];
    _descAtividades = dados['Atividades'];
    _descRelacionamentos = dados['Relacionamentos'];
    _idPlano = dados['idPlano'];
    _idPessoa = dados['idPessoa'];
  }
}

class bdPlanoNegocios {
  static FirebaseFirestore _bd = FirebaseFirestore.instance;

  static Future<List<PlanoNegocios>> getPlano({required int idPessoa}) async {
    var lista = <PlanoNegocios>[];

    try {
      QuerySnapshot querySnapshot =
          await _bd.collection('PlanoDeNegocios').get();

      querySnapshot.docs.forEach((docSnapshot) {
        Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;
        print(dados);
        PlanoNegocios plano = PlanoNegocios.fromJson(dados);
        lista.add(plano);
      });
    } catch (e) {
      print("Erro ao obter planos: $e");
    }

    return lista; 
  }

  static setPlanoNegocio({required PlanoNegocios plano}) async {
    final My_plano = <String, dynamic>{
      "Clientes": plano.descClientes,
      "Atividades": plano.descAtividades,
      "Canais": plano.descCanais,
      "Custos": plano.descCustos,
      "Parcerias": plano.descParcerias,
      "Receita": plano.descReceita,
      "Recursos": plano.descRecursos,
      "Relacionamentos": plano.descRelacionamentos,
      "Valor": plano.descValor,
      "idPessoa": plano.idPessoa,
      "idPlano": plano.idPlano
    };

    await _bd.collection("PlanoDeNegocios").add(My_plano);
  }
}

class controllerPlanoNegocios {
  static criarPlano(novo) {
    bdPlanoNegocios.setPlanoNegocio(plano: novo);
  }

  static editarPlano() {
    //Todo
  }

  static deletarPlano() {
    //Todo
  }

  static getPlano({required int idPessoa}) {
    return bdPlanoNegocios.getPlano(idPessoa: idPessoa);
  }
}
