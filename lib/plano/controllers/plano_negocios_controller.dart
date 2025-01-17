import 'package:app_gp9/plano/models/plano_negocios_model.dart';
import 'package:app_gp9/plano/repository/plano_negocios_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_gp9/pessoa.dart';

class ControllerPlanoNegocios{
  
  static Future<PlanoNegocios> getPlano(
      {required DocumentReference? referencia}) async {
    //Retorna um objeto do Tipo PlanoNegocios
    //Entrada: Referência ao documento na coleção Planos.
    var json = await PlanoNegociosRepository.getPlano(reference: referencia);
    var plano = PlanoNegocios.fromJson(json);
    return plano;
  }

  static Future<void> updatePlano(
      {required DocumentReference? referencia,
      required Map<String, dynamic> novosDados}) async {
    await PlanoNegociosRepository.updatePlan(reference: referencia, dados: novosDados);
  }

  static Future<void> deletePlano({required PlanoNegocios plano, required String idUsuario})async{

    Pessoa? pessoa = await PessoaCollection.getPessoa(idUsuario);
    await PlanoNegociosRepository.deletePlan(reference: plano.referencia!, idPessoa: pessoa!.idPessoa);


  }

  static Future<void> createEmptyPlan({required String nome, required String idUsuario}) async{
    
    Map<String,dynamic>? mascara = {"total":0};
    
    PlanoNegocios registro = PlanoNegocios(mascara, mascara, mascara, mascara, mascara, mascara, mascara, mascara, mascara, nome);
    await PlanoNegociosRepository.createPlan(plano: registro, idUsuario: idUsuario);
  }

}