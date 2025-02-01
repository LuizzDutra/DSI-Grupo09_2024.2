import 'package:app_gp9/pessoa.dart';
import 'package:app_gp9/plano/model/plano_negocios.dart';
import 'package:app_gp9/plano/repository/plano_negocio_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerPlanoNegocios {
  
  final repository = PlanoNegocioRepository();  
  
  
  Future<PlanoNegocios> getPlano(
      {required DocumentReference? referencia}) async {
    //Retorna um objeto do Tipo PlanoNegocios
    //Entrada: Referência ao documento na coleção Planos.
    var json = await repository.getPlano(reference: referencia);
    var plano = PlanoNegocios.fromJson(json);
    return plano;
  }

  Future<void> updatePlano(
      {required DocumentReference? referencia,
      required Map<String, dynamic> novosDados}) async {
    await repository.updatePlan(
        reference: referencia, dados: novosDados);
  }

  Future<void> deletePlano(
      {required PlanoNegocios plano, required String idUsuario}) async {
    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
    await repository.deletePlan(
        reference: plano.referencia!, idPessoa: pessoa!.idPessoa);
  }

  Future<void> createEmptyPlan(
      {required String nome, required String idUsuario}) async {
    Map<String, dynamic>? mascara = {"total": 0};

    PlanoNegocios registro = PlanoNegocios(mascara, mascara, mascara, mascara,
        mascara, mascara, mascara, mascara, mascara, nome);
    await repository.createPlan(
        plano: registro, idUsuario: idUsuario);
  }
}
