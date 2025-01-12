
import 'package:app_gp9/swot/BrancodeDados/Swot_BD.dart';
import 'package:app_gp9/swot/models/swot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gp9/pessoa.dart';

class controllerSwot {
  // Obter uma análise SWOT
  static Future<AnaliseSwot> getSwot({required DocumentReference referencia}) async {
    var json = await bdSwot.getSwot(reference: referencia, swotId: '');
    var swot = AnaliseSwot.fromMap(referencia.id, json as Map<String, dynamic>);
    return swot;
  }

  // Atualizar análise SWOT
  static Future<void> updateSwot({required DocumentReference referencia, required Map<String, dynamic> novosDados}) async {
    await bdSwot.updateSwot(reference: referencia, dados: novosDados);
  }

  // Deletar análise SWOT
  static Future<void> deleteSwot({required AnaliseSwot swot, required String idUsuario}) async {
    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
    await bdSwot.deleteSwot(reference: swot.referencia, idPessoa: pessoa!.idPessoa);
  }

  // Criar uma nova análise SWOT
  static Future<void> createEmptySwot({required String nome, required String idUsuario}) async {
    // Criar a estrutura inicial da análise SWOT
    Map<String, dynamic> analise = {
      'AmbienteExterno': {
        'Ameacas': [],
        'Oportunidades': []
      },
      'AmbienteInterno': {
        'Forcas': [],
        'Fraquezas': []
      },
      'nome': '',
    };
    AnaliseSwot registro = AnaliseSwot(id: "", nome: nome, analise: analise, referencia: FirebaseFirestore.instance.collection('Swots').doc());
    await bdSwot.createSwot(swot: registro, idUsuario: idUsuario);
  }
}




