import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meta_model.dart';

class MetasBD {
  static final FirebaseFirestore _bd = FirebaseFirestore.instance;

  
  static Future<void> criarMeta({required Meta meta}) async {
    Map<String, dynamic> dados = meta.toMap();
    try {
      
      DocumentReference referencia = await _bd.collection('Metas').add(dados);

      
      await atualizarMeta(referencia: referencia, novosDados: {'referencia': referencia});
    } catch (e) {
      throw Exception("Erro ao adicionar Meta: $e");
    }
  }


  static Future<void> atualizarMeta({
    required DocumentReference referencia,
    required Map<String, dynamic> novosDados,
  }) async {
    try {
      await referencia.update(novosDados);
    } catch (e) {
      throw Exception("Erro ao atualizar Meta: $e");
    }
  }

 
  static Future<void> deletarMeta({required DocumentReference referencia}) async {
    try {
      await referencia.delete();
    } catch (e) {
      throw Exception("Erro ao deletar Meta: $e");
    }
  }

 
  static Future<Map<String, dynamic>> getMeta({required DocumentReference referencia}) async {
    try {
      DocumentSnapshot doc = await referencia.get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('A meta não existe ou está vazia.');
      }

      if (doc.data() is Map<String, dynamic>) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('O documento não contém um Map<String, dynamic> válido.');
      }
    } catch (e) {
      throw Exception("Erro ao obter Meta: $e");
    }
  }


  static Future<List<Meta>> getMetas() async {
    try {
      QuerySnapshot query = await _bd.collection('Metas').get();
      return query.docs
          .map((doc) => Meta.fromMap(doc.id, doc.data() as Map<String, dynamic>, doc.reference))
          .toList();
    } catch (e) {
      throw Exception("Erro ao obter todas as Metas: $e");
    }
  }

 
  static Future<void> atualizarValorAtual({
    required DocumentReference referencia,
    required double novoValor,
  }) async {
    try {
      await referencia.update({'valorAtual': novoValor});
    } catch (e) {
      throw Exception("Erro ao atualizar valor atual da meta: $e");
    }
  }

 
  static Future<double> obterProgresso({required DocumentReference referencia}) async {
    try {
      var dados = await getMeta(referencia: referencia);
      double valorInicio = (dados['valorInicio'] as num?)?.toDouble() ?? 0.0;
      double valorAtual = (dados['valorAtual'] as num?)?.toDouble() ?? 0.0;
      double valorFim = (dados['valorFim'] as num?)?.toDouble() ?? 0.0;

      if (valorFim == 0) return 0;
      return ((valorAtual - valorInicio) / (valorFim - valorInicio)) * 100;
    } catch (e) {
      throw Exception("Erro ao obter progresso da Meta: $e");
    }
  }
}