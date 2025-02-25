import 'package:app_gp9/plano/Model/plano_negocios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPlanoNegocioRepository {
  Future<Map<String, dynamic>> getPlano(
      {required DocumentReference? reference});
  Future<void> createPlan(
      {required PlanoNegocios plano, required String idUsuario});
  Future<void> updatePlan(
      {required DocumentReference? reference,
      required Map<String, dynamic> dados});
  Future<void> deletePlan(
      {required DocumentReference reference, required int idPessoa});
}
