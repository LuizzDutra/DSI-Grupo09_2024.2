import 'package:app_gp9/pessoa.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilController{
  static Future<Pessoa> getPessoaLogada() async{
  Pessoa? pessoa = await PessoaCollection.getPessoa(FirebaseAuth.instance.currentUser!.uid);
  return pessoa!;
  }
}