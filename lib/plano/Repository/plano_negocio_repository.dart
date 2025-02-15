import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/plano/Repository/plano_negocio_repository_interface.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanoNegocioRepository implements IPlanoNegocioRepository{
  final FirebaseFirestore _bd = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> getPlano(
      {required DocumentReference? reference}) async {
    var dados = await reference!.get();
    if (dados.data() is Map<String, dynamic>) {
      return dados.data() as Map<String, dynamic>;
    } else {
      throw Exception('O documento não contém um Map<String, dynamic> válido');
    }
  }

  @override
  Future<void> createPlan(
      {required PlanoNegocios plano, required String idUsuario}) async {
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
    } catch (e) {
      throw Exception("Erro ao adicionar $e");
    }
  }

  @override
  Future<void> updatePlan(
      {required DocumentReference? reference,
      required Map<String, dynamic> dados}) async {
    try {
      await reference!.update(dados);
    } catch (e) {
      throw Exception("Erro ao deletar");
    }
  }

  @override
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
      print('Erro ao atualizar o campo "planos": $e');
    }
  }
}
