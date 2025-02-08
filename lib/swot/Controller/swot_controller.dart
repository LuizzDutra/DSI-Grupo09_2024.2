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
        return []; // Retorna uma lista vazia se não houver forcas
      }
    } catch (e) {
      throw Exception("Erro ao obter as forças: $e");
    }
  }

  // gerenciando fraquezas

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
      // Primeiro remove a força antiga
      await reference.update({
        'analise.AmbienteInterno.Fraquezas':
            FieldValue.arrayRemove([antigaFraqueza])
      });

      // Depois adiciona a nova força
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
      var json = await bdSwot.getSwot(reference: reference);
      // Verifica se a chave existe antes de acessar
      if (json['analise'] != null &&
          json['analise']['AmbienteInterno'] != null &&
          json['analise']['AmbienteInterno']['Fraquezas'] != null) {
        return List<String>.from(
            json['analise']['AmbienteInterno']['Fraquezas']);
      } else {
        return []; // Retorna uma lista vazia se não houver Fraquezas
      }
    } catch (e) {
      throw Exception("Erro ao obter as Fraquezas: $e");
    }
  }

  //Gerrenciando ameaças

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
      var json = await bdSwot.getSwot(reference: reference);
      // Verifica se a chave existe antes de acessar
      if (json['analise'] != null &&
          json['analise']['AmbienteExterno'] != null &&
          json['analise']['AmbienteExterno']['Ameacas'] != null) {
        return List<String>.from(
            json['analise']['AmbienteExterno']['Ameacas']);
      } else {
        return []; 
      }
    } catch (e) {
      throw Exception("Erro ao obter as Ameaças: $e");
    }
  }

  //gerenciando oportunidades

  static Future<void> addOporrtunidades(
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
      var json = await bdSwot.getSwot(reference: reference);
      // Verifica se a chave existe antes de acessar
      if (json['analise'] != null &&
          json['analise']['AmbienteExterno'] != null &&
          json['analise']['AmbienteExterno']['Oportunidades'] != null) {
        return List<String>.from(
            json['analise']['AmbienteExterno']['Oportunidades']);
      } else {
        return []; 
      }
    } catch (e) {
      throw Exception("Erro ao obter as Oportunidades: $e");
    }
  }

}
