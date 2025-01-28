import 'package:app_gp9/empresa.dart';
import 'package:app_gp9/pessoa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilController{
  static Future<Pessoa> getPessoaLogada() async{
  Pessoa? pessoa = await PessoaCollection.getPessoa(FirebaseAuth.instance.currentUser!.uid);
  return pessoa!;
  }
  static Future<Empresa> getEmpresa(DocumentReference reference) async{
    return await EmpresaCollection.getEmpresaByReference(reference);
  }

  static Future<DocumentReference?> getPessoaLogadaReference() async{
    return await PessoaCollection.getPessoaReference(FirebaseAuth.instance.currentUser!.uid);
  }

  static void saveData(String nome, String nomeNegocio, String segmento, String descricao) async{
    DocumentReference? pessoaRef = await getPessoaLogadaReference();
    var pessoaDoc = await pessoaRef!.get();
    var data = pessoaDoc.data() as Map<String, dynamic>;
    DocumentReference empresaRef = await data["empresa"];
    pessoaRef.update({"nome": nome});
    empresaRef.update({
      "nomeNegocio": nomeNegocio,
      "segmento": segmento,
      "descricao": descricao,
    });

  }
}