import 'package:sqflite/sqflite.dart';


class UserDatabase{

  Future<Database> abrirDb() async{
    var dbPathGlobal = await getDatabasesPath();
    var dbPath = '$dbPathGlobal/usuarios.db';

    Database database = await openDatabase(dbPath, version: 1, 
      onCreate: (Database db, int version) async{
        //To-do implementer hashing com bcrypt
        await db.execute('CREATE TABLE Users(email VARCHAR PRIMARY KEY, nome TEXT, senha VARCHAR)');
        await db.execute('INSERT INTO Users(email, nome, senha) VALUES("luizzidutra@gmail.com", "Luiz", "admin000")');
    });
    return database;
  }

  Future<dynamic> pegarTabelaUsuario() async{
    var db = await UserDatabase().abrirDb();
    var query = await db.rawQuery("SELECT * FROM Users");
    return query;
  }

}