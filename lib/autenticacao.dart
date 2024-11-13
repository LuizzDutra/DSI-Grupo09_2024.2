import 'package:sqflite/sqflite.dart';
import 'package:app_gp9/database_usuarios.dart';

class Autenticar{
  static String usuarioLogado = "";

  static Future<void> registrar(String email, String nome, String senha) async{

      if(!nomeValido(nome)){
        throw Exception("Nome possue caracteres invalidos");
      }
      if (await emailExiste(email)){
        throw Exception("Email já em uso");
      }
      Database db = await UserDatabase().abrirDb();
      await db.transaction((txn) async{
        await txn.rawInsert('INSERT INTO Users(email, nome, senha) VALUES(?, ?, ?)', [email, nome, senha]);
      });
  }

  static Future<void> logar(String email, String senha) async{
    if(!await emailExiste(email)){
      throw Exception("Email não existe");
    }

    Database db = await UserDatabase().abrirDb();
    List query = await db.rawQuery("SELECT senha FROM Users WHERE email=?", [email]);
    if(query[0]["senha"] == senha){
      usuarioLogado = email;
    }else{
      throw Exception("Senha incorreta");
    }

  }

  static Future<bool> emailExiste(String email) async {
    Database db = await UserDatabase().abrirDb();
    List query = await db.rawQuery("SELECT * FROM Users WHERE email=?", [email]);
    if(query.isNotEmpty){
      return true;
    }
    return false;
  }

  static bool nomeValido(String nome){
    return !RegExp(r'\d').hasMatch(nome);
  }

}