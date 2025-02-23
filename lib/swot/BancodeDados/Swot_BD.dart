import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/swot/models/swot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class bdSwot {
  static final FirebaseFirestore _bd = FirebaseFirestore.instance;

  // Obter uma análise SWOT
  static Future<void> createSwot(
      {required AnaliseSwot swot, required String idUsuario}) async {
    Map<String, dynamic> dados = swot.toMap();
    try {
      // Cria o documento SWOT
      DocumentReference? referencia = await _bd.collection('Swots').add(dados);

      // Atualiza a referência da análise SWOT no campo 'referencia'
      await updateSwot(
          reference: referencia, dados: {'referencia': referencia});

      // Obter a pessoa e seu campo de swots
      Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
      Map<String, dynamic>? swotsRef = pessoa?.swots;

      var novaChave = swotsRef?['total'] ?? 0;
      //swotsRef?[novaChave.toString()] = referencia;

      // Atualizar o total de swots
      int temp = novaChave + 1;
      swotsRef?['total'] = temp;

      // Atualiza o campo 'swots' na pessoa
      await atualizarSwots(
          idUsuario, {'total': temp, novaChave.toString(): referencia});
    } catch (e) {
      throw Exception("Erro ao adicionar SWOT: ${e}");
    }
  }

  // Atualizar uma análise SWOT
  static Future<void> updateSwot(
      {required DocumentReference reference,
      required Map<String, dynamic> dados}) async {
    try {
      await reference.update(dados);
    } catch (e) {
      throw Exception("Erro ao atualizar SWOT");
    }
  }

  // Deletar uma análise SWOT
  static Future<void> deleteSwot(
      {required DocumentReference reference, required int idPessoa}) async {
    try {
      final referencePessoa = await _bd
          .collection("Pessoas")
          .where("idPessoa", isEqualTo: idPessoa)
          .get();
      for (var doc in referencePessoa.docs) {
        var jsonCompleto = doc.data();
        Map<String, dynamic>? jsonSwots = jsonCompleto['swots'];
        Map<String, dynamic>? auxiliar = Map.from(jsonSwots!);
        for (var iterador in jsonSwots.entries) {
          if (iterador.value == reference) {
            auxiliar.remove(iterador.key);
            auxiliar["total"] -= 1;
            break;
          }
        }
        doc.reference.update({"swots": auxiliar});
        await reference.delete();
        break;
      }
    } catch (e) {
      throw Exception("Erro ao deletar SWOT: $e");
    }
  }

  // Atualizar os Swots de um usuário
  static Future<void> atualizarSwots(
      String idUsuario, Map<String, dynamic>? novosSwots) async {
    try {
      final CollectionReference collection = _bd.collection('Pessoas');
      QuerySnapshot querySnapshot =
          await collection.where('idUsuario', isEqualTo: idUsuario).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documento = querySnapshot.docs.first;
        await documento.reference.update({
          'swots.${novosSwots?['total']}':
              novosSwots?[(novosSwots['total'] - 1).toString()],
          'swots.total': novosSwots?['total']
        });
      }
    } catch (e) {
      throw Exception('Erro ao atualizar o campo "swots": $e');
    }
  }

  // Método para buscar uma análise SWOT
  static Future<Map<String, dynamic>> getSwot(
      {required DocumentReference? reference}) async {
    var dados = await reference!.get();

    if (!dados.exists || dados.data() == null) {
      throw Exception('O documento nao existe ou esta vazio');
    }

    if (dados.data() is Map<String, dynamic>) {
      return dados.data() as Map<String, dynamic>;
    } else {
      throw Exception('O documento nao contem um Map<String, dynamic> valido');
    }
  }

  // Gerenciando forças

  static Future<void> addforca(
      {required DocumentReference reference, required String novaForca}) async {
    try {
      await reference.update({
        'analise.AmbienteInterno.Forcas': FieldValue.arrayUnion([novaForca])
      });
    } catch (e) {
      throw Exception("Erro ao adicionar Força: $e");
    }
  }

  static Future<void> removerForca(
      {required DocumentReference reference,
      required String antigaForca}) async {
    try {
      await reference.update({
        'analise.AmbienteInterno.Forcas': FieldValue.arrayRemove([antigaForca])
      });
    } catch (e) {
      throw Exception("Erro ao remover Força: $e");
    }
  }

  static Future<void> updateForca(
      {required DocumentReference reference,
      required String antigaForca,
      required String novaForca}) async {
    try {
      // Remove primeiro a força antiga
      await reference.update({
        'analise.AmbienteInterno.Forcas': FieldValue.arrayRemove([antigaForca])
      });

      // Depois adiciona a nova força
      await reference.update({
        'analise.AmbienteInterno.Forcas': FieldValue.arrayUnion([novaForca])
      });
    } catch (e) {
      throw Exception("Erro ao atualizar Força: $e");
    }
  }

  static Future<List<String>> obterForcas(
      {required DocumentReference reference}) async {
    try {
      var json = await getSwot(reference: reference);
      return List<String>.from(json['analise']['AmbienteInterno']['Forcas']);
    } catch (e) {
      throw Exception("Erro ao obter as forças: $e");
    }
  }

  // Gerenciando Fraqueza

  static Future<void> addFraquezas(
      {required DocumentReference reference,
      required String novaFraqueza}) async {
    try {
      await reference.update({
        'analise.AmbienteInterno.Fraquezas':
            FieldValue.arrayUnion([novaFraqueza])
      });
    } catch (e) {
      throw Exception("Erro ao adicionar Fraqueza: $e");
    }
  }

  static Future<void> removerFraquezas(
      {required DocumentReference reference,
      required String antigaFraqueza}) async {
    try {
      await reference.update({
        'analise.AmbienteInterno.Fraquezas':
            FieldValue.arrayRemove([antigaFraqueza])
      });
    } catch (e) {
      throw Exception("Erro ao remover Fraqueza: $e");
    }
  }

  static Future<void> updateFraquezas(
      {required DocumentReference reference,
      required String antigaFraqueza,
      required String novaFraqueza}) async {
    try {
      await reference.update({
        'analise.AmbienteInterno.Fraquezas':
            FieldValue.arrayRemove([antigaFraqueza])
      });

      await reference.update({
        'analise.AmbienteInterno.Fraquezas':
            FieldValue.arrayUnion([novaFraqueza])
      });
    } catch (e) {
      throw Exception("Erro ao atualizar Fraqueza: $e");
    }
  }

  static Future<List<String>> obterFraquezas(
      {required DocumentReference reference}) async {
    try {
      var json = await getSwot(reference: reference);
      return List<String>.from(json['analise']['AmbienteInterno']['Fraquezas']);
    } catch (e) {
      throw Exception("Erro ao obter as Fraquezas: $e");
    }
  }

  // Gerenciando Ameaça

  static Future<void> addAmeacas(
      {required DocumentReference reference,
      required String novaAmeaca}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Ameacas':
            FieldValue.arrayUnion([novaAmeaca])
      });
    } catch (e) {
      throw Exception("Erro ao adicionar Ameaça: $e");
    }
  }

  static Future<void> removerAmeacas(
      {required DocumentReference reference,
      required String antigaAmeaca}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Ameacas':
            FieldValue.arrayRemove([antigaAmeaca])
      });
    } catch (e) {
      throw Exception("Erro ao remover Ameaça: $e");
    }
  }

  static Future<void> updateAmeacas(
      {required DocumentReference reference,
      required String antigaAmeaca,
      required String novaAmeaca}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Ameacas':
            FieldValue.arrayRemove([antigaAmeaca])
      });

      await reference.update({
        'analise.AmbienteExterno.Ameacas':
            FieldValue.arrayUnion([novaAmeaca])
      });
    } catch (e) {
      throw Exception("Erro ao atualizar Ameaça: $e");
    }
  }

  static Future<List<String>> obterAmeacas(
      {required DocumentReference reference}) async {
    try {
      var json = await getSwot(reference: reference);
      return List<String>.from(json['analise']['AmbienteExterno']['Ameacas']);
    } catch (e) {
      throw Exception("Erro ao obter as Ameacas: $e");
    }
  }

  // Gerenciando Oportunidade

  static Future<void> addOportunidades(
      {required DocumentReference reference,
      required String novaOportunidade}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Oportunidades':
            FieldValue.arrayUnion([novaOportunidade])
      });
    } catch (e) {
      throw Exception("Erro ao adicionar Oportunidade: $e");
    }
  }

  static Future<void> removerOportunidades(
      {required DocumentReference reference,
      required String antigaOportunidade}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Oportunidades':
            FieldValue.arrayRemove([antigaOportunidade])
      });
    } catch (e) {
      throw Exception("Erro ao remover Oportunidade: $e");
    }
  }

  static Future<void> updateOportunidades(
      {required DocumentReference reference,
      required String antigaOportunidade,
      required String novaOportunidade}) async {
    try {
      await reference.update({
        'analise.AmbienteExterno.Oportunidades':
            FieldValue.arrayRemove([antigaOportunidade])
      });

      await reference.update({
        'analise.AmbienteExterno.Oportunidades':
            FieldValue.arrayUnion([novaOportunidade])
      });
    } catch (e) {
      throw Exception("Erro ao atualizar Oportunidade: $e");
    }
  }

  static Future<List<String>> obterOportunidades(
      {required DocumentReference reference}) async {
    try {
      var json = await getSwot(reference: reference);
      return List<String>.from(json['analise']['AmbienteExterno']['Oportunidades']);
    } catch (e) {
      throw Exception("Erro ao obter as Oportunidades: $e");
    }
  }
  
}
