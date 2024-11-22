import 'package:app_gp9/database_usuarios.dart';

class Autenticar{
  static String usuarioLogado = "";
  late MyDatabase db;

  Autenticar._init();

  static Future<Autenticar> init() async{
    Autenticar auth = Autenticar._init();
    auth.db = await MyDatabase.init();
    return auth;
  }

  Future<void> registrar(String email, String nome, String senha) async{
      if(!nomeValido(nome)){
        throw "Nome possue caracteres invalidos";
      }
      if (await emailExiste(email)){
        throw "Email já em uso";
      }
      await db.inserirUsuario(email, nome, senha);
  }

  Future<void> logar(String email, String senha) async{
    if(!await emailExiste(email)){
      throw "Email não existe";
    }
    if(usuarioLogado != ""){
      throw Exception("Já existe um usuário logado");
    }

    if(await db.checarSenha(email, senha)){
      usuarioLogado = email;
    }else{
      throw "Senha incorreta";
    }

  }

  Future<void> removerUsuario(String email, String senha) async{
    if(await db.checarSenha(email, senha)){
      db.removerRegistroUsuario(email);
    }else{
      throw "Senha incorreta";
    }
  }

  Future<bool> emailExiste(String email) async {

    List query = await db.pegarEmail(email);
    if(query.isNotEmpty){
      return true;
    }
    return false;
  }

  bool nomeValido(String nome){
    return !RegExp(r'\d').hasMatch(nome);
  }

}