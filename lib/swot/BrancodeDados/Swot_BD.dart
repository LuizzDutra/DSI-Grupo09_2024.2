import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/swot/models/swot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class bdSwot {
  static final FirebaseFirestore _bd = FirebaseFirestore.instance;

  // Obter uma análise SWOT
  static Future<void> createSwot({required AnaliseSwot swot, required String idUsuario}) async {
  Map<String, dynamic> dados = swot.toMap();
  try {
    // Cria o documento SWOT
    DocumentReference referencia = await _bd.collection('Swots').add(dados);
    
    // Atualiza a referência da análise SWOT no campo 'referencia'
    await updateSwot(reference: referencia, dados: {'referencia': referencia});

    // Obter a pessoa e seu campo de swots
    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
    Map<String, dynamic>? swotsRef = pessoa?.swots;

    // Verificar se a chave 'total' já existe
    var nova_chave = swotsRef?['total'] ?? 1;
    swotsRef?[nova_chave.toString()] = referencia; // Adiciona a referência no campo correto

    // Atualizar o total de swots
    int temp = nova_chave + 1;
    swotsRef?['total'] = temp; // Atualiza o total de swots

    // Atualiza o campo 'swots' na pessoa
    await atualizarSwots(idUsuario, {'total': temp, nova_chave.toString(): referencia});
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
  static Future<void> atualizarSwots(String idUsuario, Map<String, dynamic>? novosSwots) async {
  try {
    final CollectionReference collection = _bd.collection('Pessoas');
    QuerySnapshot querySnapshot = await collection.where('idUsuario', isEqualTo: idUsuario).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documento = querySnapshot.docs.first;
      await documento.reference.update({
        'swots': novosSwots, // Atualiza todo o campo 'swots'
      });
    }
  } catch (e) {
    throw Exception('Erro ao atualizar o campo "swots": $e');
  }
}


  // Método para buscar uma análise SWOT
  static Future<AnaliseSwot> getSwot({required String swotId, required DocumentReference<Object?> reference}) async {
    try {
      final swotDoc = await _bd.collection('Swots').doc(swotId).get();
      if (swotDoc.exists) {
        return AnaliseSwot.fromMap(swotDoc.id, swotDoc.data()!);
      } else {
        throw Exception('SWOT não encontrado');
      }
    } catch (e) {
      throw Exception("Erro ao obter SWOT: $e");
    }
  }


  
}
