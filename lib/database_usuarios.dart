import 'package:sqflite/sqflite.dart';


class MyDatabase{

  MyDatabase._init();

  late Database db;

  static Future<MyDatabase> init() async{
    MyDatabase myDatabase = MyDatabase._init();

    myDatabase.db = await abrirDb();

    return myDatabase;
  }

  static Future<Database> abrirDb() async{
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

  Future<void> fecharDb() async{
    await db.close();
  }

  Future<void> inserirUsuario(String email, String nome, String senha) async{
    db.transaction((txn) async{
        await txn.rawInsert('INSERT INTO Users(email, nome, senha) VALUES(?, ?, ?)', [email, nome, senha]);
    });
  }

  Future<List> pegarEmail(String email) async{
    return db.rawQuery("SELECT * FROM Users WHERE email=?", [email]);
  }

  Future<List> pegarSenha(String email) async{
    return db.rawQuery("SELECT senha FROM Users WHERE email=?", [email]);
  }

  Future<dynamic> pegarTabelaUsuario() async{
    var query = await db.rawQuery("SELECT * FROM Users");
    return query;
  }

  

}