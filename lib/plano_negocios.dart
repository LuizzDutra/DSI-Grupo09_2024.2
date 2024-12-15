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
  String? _nome;

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
  String? get descNome => _nome;

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
  set descNome(String? value) => _nome = value;

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
      this._nome);

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
    _idPlano = dados['idPlano'];
    _idPessoa = dados['idPessoa'];
    _nome = dados['nome'];
  }

  Map<String, dynamic> toJson(PlanoNegocios plano) {
    Map<String, dynamic> mapa = {
      "Clientes": _descClientes,
      "Valor": _descValor,
      "Custos": _descCustos,
      "Parcerias": _descParcerias,
      "Receita": _descReceita,
      "Recursos": _descCustos,
      "Atividades": _descAtividades,
      "Relacionamentos": _descRelacionamentos,
      "idPlano": _idPlano,
      "idPessoa": _idPessoa,
      "nome": _nome
    };

    return mapa;
  }
}

class bdPlanoNegocios {
  static FirebaseFirestore _bd = FirebaseFirestore.instance;

  static Future<List<PlanoNegocios>> getPlano({required int idPessoa}) async {
    var lista = <PlanoNegocios>[];

    try {
      QuerySnapshot querySnapshot = await _bd
          .collection('PlanoDeNegocios')
          .where('idPessoa', isEqualTo: idPessoa)
          .get();

      querySnapshot.docs.forEach((docSnapshot) {
        Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;
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
      "idPlano": plano.idPlano,
      "nome": plano.descNome,
    };

    await _bd.collection("PlanoDeNegocios").add(My_plano);
  }

  static Future<void> DeletarPlano({required PlanoNegocios plano}) async {
    try {
      CollectionReference planosCollection = _bd.collection('PlanoDeNegocios');

      QuerySnapshot query = await planosCollection
          .where('idPlano', isEqualTo: plano._idPlano)
          .where('idPessoa', isEqualTo: plano.idPessoa)
          .get();

      if (query.docs.isNotEmpty) {
        String id = query.docs.first.id;

        await planosCollection.doc(id).delete();
      }
    } catch (e) {
      print("Erro ao deletar Plano de Negócio: $e");
    }
  }

  static Future<void> updatePlanoNegocio(
      int? idPessoa, int? idPlano, Map<String, dynamic> json) async {
    try {
      CollectionReference planosCollection = _bd.collection('PlanoDeNegocios');

      QuerySnapshot query = await planosCollection
          .where('idPlano', isEqualTo: idPlano)
          .where('idPessoa', isEqualTo: idPessoa)
          .get();

      if (query.docs.isNotEmpty) {
        // Obtém o ID do primeiro documento encontrado
        String id = query.docs.first.id;

        // Atualiza o documento com o ID encontrado
        await planosCollection.doc(id).update(json);

        print("Plano de Negócio atualizado com sucesso! $json");
      }
    } catch (e) {
      print("Erro ao atualizar Plano de Negócio: $e");
    }
  }

  static Future<String?> getCampoPlano({
    required int idPessoa,
    required int idPlano,
    required String campo,
  }) async {
    try {
      // Consulta para buscar o documento com base no idPessoa e idPlano
      QuerySnapshot querySnapshot = await _bd
          .collection('PlanoDeNegocios')
          .where('idPessoa', isEqualTo: idPessoa)
          .where('idPlano', isEqualTo: idPlano)
          .get();

      // Verifica se algum documento foi encontrado
      if (querySnapshot.docs.isNotEmpty) {
        // Obtém o primeiro documento encontrado
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Obtém os dados do documento como um mapa
        Map<String, dynamic> dados = docSnapshot.data() as Map<String, dynamic>;

        // Verifica se o campo existe no documento
        if (dados.containsKey(campo)) {
          return dados[campo].toString(); // Retorna o valor do campo
        } else {
          print("Campo '$campo' não encontrado.");
          return null;
        }
      } else {
        print(
            "Documento com idPessoa '$idPessoa' e idPlano '$idPlano' não encontrado.");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar campo no plano: $e");
      return null;
    }
  }
}

class controllerPlanoNegocios {
  static criarPlano(novo) {
    bdPlanoNegocios.setPlanoNegocio(plano: novo);
  }

  static editarPlano(PlanoNegocios plano, Map<String, dynamic> _json) {
    int? id_pessoa = plano._idPessoa;
    int? id_plano = plano.idPlano;

    bdPlanoNegocios.updatePlanoNegocio(plano._idPessoa, plano.idPlano, _json);
  }

  static deletarPlano(PlanoNegocios _plano) {
    bdPlanoNegocios.DeletarPlano(plano: _plano);
  }

  static getPlano({required int numeroPessoa}) {
    return bdPlanoNegocios.getPlano(idPessoa: numeroPessoa);
  }
}
