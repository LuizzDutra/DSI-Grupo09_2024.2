import 'package:cloud_firestore/cloud_firestore.dart';
import '../banco_de_dados/metas_bd.dart';
import '../models/meta_model.dart';

class ControladorMetas {

  static Future<void> criarMeta({
    required String titulo,
    required double valorInicio,
    required double valorFim,
    required String descricao,
    required DateTime prazo,
  }) async {
    try {
      
      Meta novaMeta = Meta(
        id: "",
        titulo: titulo,
        valorInicio: valorInicio,
        valorAtual: valorInicio, 
        valorFim: valorFim,
        descricao: descricao,
        prazo: prazo,
        referencia: FirebaseFirestore.instance.collection('Metas').doc(),
      );

      await MetasBD.criarMeta(meta: novaMeta);
    } catch (e) {
      throw Exception("Erro ao criar meta: $e");
    }
  }

  
  static Future<Meta> getMeta({required DocumentReference referencia}) async {
    try {
      var json = await MetasBD.getMeta(referencia: referencia);
      return Meta.fromMap(referencia.id, json, referencia);
    } catch (e) {
      throw Exception("Erro ao obter meta: $e");
    }
  }


  static Future<List<Meta>> getMetas() async {
    try {
      return await MetasBD.getMetas();
    } catch (e) {
      throw Exception("Erro ao obter lista de metas: $e");
    }
  }

  
  static Future<void> alterarMeta({
    required DocumentReference referencia,
    required Map<String, dynamic> novosDados,
  }) async {
    try {
      await MetasBD.atualizarMeta(referencia: referencia, novosDados: novosDados);
    } catch (e) {
      throw Exception("Erro ao alterar meta: $e");
    }
  }

  
  static Future<void> excluirMeta({required DocumentReference referencia}) async {
    try {
      await MetasBD.deletarMeta(referencia: referencia);
    } catch (e) {
      throw Exception("Erro ao excluir meta: $e");
    }
  }

 
  static Future<void> atualizarValorAtual({
    required DocumentReference referencia,
    required double novoValor,
  }) async {
    try {
      await MetasBD.atualizarValorAtual(referencia: referencia, novoValor: novoValor);
    } catch (e) {
      throw Exception("Erro ao atualizar valor atual da meta: $e");
    }
  }

  
  static Future<double> calcularProgresso({required DocumentReference referencia}) async {
    try {
      return await MetasBD.obterProgresso(referencia: referencia);
    } catch (e) {
      throw Exception("Erro ao calcular progresso da meta: $e");
    }
  }
}