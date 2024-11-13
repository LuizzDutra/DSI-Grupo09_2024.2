import 'package:sqflite/sqflite.dart';
import 'package:app_gp9/database_usuarios.dart';

class Autenticar{

  Future<void> registrar(String email, String nome, String senha) async{

      if(!nomeValido(nome)){
        throw Exception("Nome possue caracteres invalidos");
      }
      if (await emailValido(email)){
        Database db = await UserDatabase().abrirDb();
        await db.transaction((txn) async{
          await txn.rawInsert('INSERT INTO Users(email, nome, senha) VALUES(?, ?, ?)', [email, nome, senha]);
        });
      }else{
        throw Exception("Email já em uso");
      }
  }

  Future<bool> emailValido(String email) async {
    Database db = await UserDatabase().abrirDb();
    List query = await db.rawQuery("SELECT * from Users WHERE email=?", [email]);
    if(query.isNotEmpty){
      return false;
    }
    return true;
  }

  bool nomeValido(String nome){
    return !RegExp(r'\d').hasMatch(nome);
  }


}