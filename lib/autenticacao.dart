import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gp9/pessoa.dart';

class ControladorAutenticar {
  static String usuarioLogado = "";

  static Future<void> registrar(String email, String senha, String nome) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      PessoaCollection.adicionarPessoa(credential.user!.uid, nome, email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'A senha é muito fraca.';
      } else if (e.code == 'weak-password') {
        throw 'Email já em uso';
      }
      throw e.code.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> logar(String email, String senha) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Email não cadastrado';
      } else if (e.code == 'wrong-password') {
        throw 'Senha incorreta';
      }
      throw e.code.toString();
    } catch (e) {
      throw e.toString();
    }
  }


}
