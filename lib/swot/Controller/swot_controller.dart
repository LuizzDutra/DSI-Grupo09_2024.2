import 'package:app_gp9/swot/BancodeDados/Swot_BD.dart';
import 'package:app_gp9/swot/models/swot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gp9/pessoa.dart';

class controllerSwot {
  // Obter uma análise SWOT
  static Future<AnaliseSwot> getSwot(
      {required DocumentReference? referencia}) async {
    var json = await bdSwot.getSwot(
      reference: referencia,
    );
    var swot = AnaliseSwot.fromMap(referencia!.id, json);
    return swot;
  }

  // Atualizar análise SWOT
  static Future<void> updateSwot(
      {required DocumentReference referencia,
      required Map<String, dynamic> novosDados}) async {
    await bdSwot.updateSwot(reference: referencia, dados: novosDados);
  }

  // Deletar análise SWOT
  static Future<void> deleteSwot(
      {required AnaliseSwot swot, required String idUsuario}) async {
    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
    await bdSwot.deleteSwot(
        reference: swot.referencia!, idPessoa: pessoa!.idPessoa);
  }

  // Criar uma nova análise SWOT
  static Future<void> createEmptySwot(
      {required String nome, required String idUsuario}) async {
    // Criar a estrutura inicial da análise SWOT
    Map<String, dynamic> analise = {
      'AmbienteExterno': {'Ameacas': [], 'Oportunidades': []},
      'AmbienteInterno': {'Forcas': [], 'Fraquezas': []},
    };
    AnaliseSwot registro = AnaliseSwot(
        id: "",
        nome: nome,
        analise: analise,
        referencia: FirebaseFirestore.instance.collection('Swots').doc());
    await bdSwot.createSwot(swot: registro, idUsuario: idUsuario);
  }

  //Gerenciar Forças

  static Future<void> addForca(
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
      // Primeiro remove a força antiga
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
      var json = await bdSwot.getSwot(reference: reference);
      // Verifica se a chave existe antes de acessar
      if (json['analise'] != null &&
          json['analise']['AmbienteInterno'] != null &&
          json['analise']['AmbienteInterno']['Forcas'] != null) {
        return List<String>.from(json['analise']['AmbienteInterno']['Forcas']);
      } else {
        return []; // Retorna uma lista vazia se não houver Forcas
      }
    } catch (e) {
      throw Exception("Erro ao obter as forças: $e");
    }
  }
}
