import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanoNegocioRepository {
  final FirebaseFirestore _bd = FirebaseFirestore.instance;
  final List<PlanoNegocios> _cache = [];

  Future<List<PlanoNegocios>> getPlanos({required String idUsuario}) async {
    if (_cache.isNotEmpty) {
      return _cache;
    }

    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);

    List<PlanoNegocios> lista = [];

    for (var chave in pessoa!.planos!.keys) {
      if (chave != 'total') {
        var plano = await getPlano(reference: pessoa.planos![chave]);
        lista.add(PlanoNegocios.fromJson(plano));
      }
    }
    _cache.addAll(lista);
    return _cache;
  }

  Future<Map<String, dynamic>> getPlano(
      {required DocumentReference? reference}) async {
    var dados = await reference!.get();
    if (dados.data() is Map<String, dynamic>) {
      return dados.data() as Map<String, dynamic>;
    } else {
      throw Exception('O documento não contém um Map<String, dynamic> válido');
    }
  }

  Future<void> createPlan(
      {required PlanoNegocios plano, required String idUsuario}) async {
    for (var plan in _cache) {
      if (plan.descNome == plano.descNome) {
        return;
      }
    }

    Map<String, dynamic> dados = plano.toJson();
    try {
      DocumentReference? referencia = await _bd.collection('Planos').add(dados);
      await updatePlan(
          reference: referencia, dados: {'referencia': referencia});
      Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
      Map<String, dynamic>? planosRef = pessoa?.planos;
      var nova_chave = planosRef?['total'] + 1;
      planosRef?[nova_chave.toString()] = referencia;
      int temp = planosRef?['total'] + 1;

      await atualizarPlanos(
          idUsuario, {nova_chave.toString(): referencia, 'total': temp});

      _cache.clear();
    } catch (e) {
      throw Exception("Erro ao adicionar $e");
    }
  }

  Future<void> updatePlan(
      {required DocumentReference? reference,
      required Map<String, dynamic> dados}) async {
    try {
      await reference!.update(dados);
      _cache.clear();
    } catch (e) {
      throw Exception("Erro ao deletar");
    }
  }

  Future<void> deletePlan(
      {required DocumentReference reference, required int idPessoa}) async {
    try {
      final referencePessoa = await _bd
          .collection("Pessoas")
          .where("idPessoa", isEqualTo: idPessoa)
          .get();
      for (var doc in referencePessoa.docs) {
        var jsonCompleto = doc.data();
        Map<String, dynamic>? jsonPlanos = jsonCompleto['planos'];
        Map<String, dynamic>? auxiliar = Map.from(jsonPlanos!);
        for (var iterador in jsonPlanos.entries) {
          if (iterador.value == reference) {
            print(iterador.key);
            auxiliar.remove(iterador.key);
            auxiliar["total"] -= 1;
            break;
          }
        }
        doc.reference.update({"planos": auxiliar});

        await reference.delete();
        _cache.clear();
        break;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> atualizarPlanos(
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
      rethrow;
    }
  }
}
