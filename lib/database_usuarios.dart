import 'package:app_gp9/utilitarios.dart';
import 'package:sqflite/sqflite.dart';
import 'package:conduit_password_hash/conduit_password_hash.dart';

class MyDatabase{


  late Database db;
  late PBKDF2 hashGen;
  late int defaultRounds;
  
  MyDatabase._init(){
    hashGen = PBKDF2();
    defaultRounds = 1000;
  }

  static Future<MyDatabase> init() async{
    MyDatabase myDatabase = MyDatabase._init();

    myDatabase.db = await abrirDb();

    return myDatabase;
  }

  static Future<void> criarDatabase(Database db) async{
    await db.execute('CREATE TABLE Users(email VARCHAR PRIMARY KEY, nome TEXT, hash VARCHAR(60), salt VARCHAR(16))');
  }

  static Future<Database> abrirDb() async{
    var dbPathGlobal = await getDatabasesPath();
    var dbPath = '$dbPathGlobal/usuarios.db';
    
    Database database = await openDatabase(dbPath, version: 5, 
      onCreate: (Database db, int version) async{
        criarDatabase(db);
    },onUpgrade: (db, oldVersion, newVersion) async{
        await db.execute('DROP TABLE Users');
        criarDatabase(db);
    },);
    return database;
  }

  Future<void> fecharDb() async{
    await db.close();
  }

  

  Future <void> inserirDados(String tabela, List <dynamic> lista) async{

    db.transaction((txn) async{
        String insert = await stringInserirDados(tabela, lista);
        await txn.rawInsert(insert, lista);
    });

  }

  Future <void> updateDados(String tabela, List <dynamic> colunas, List <dynamic> valores, String where) async{
    db.transaction((txn) async{
        String update = await stringUpdateDados(tabela, colunas,where);
        await txn.rawUpdate(update,valores);
    });
  
  }  
  
  Future<void> inserirUsuario(String email, String nome, String senha) async{
    db.transaction((txn) async{
        String salt = generateAsBase64String(16);
        String hash = hashGen.generateBase64Key(senha, salt, defaultRounds, 60);
        await txn.rawInsert('INSERT INTO Users(email, nome, hash, salt) VALUES(?, ?, ?, ?)', [email, nome, hash, salt]);
    });
  }

  Future<void> removerRegistroUsuario(String email) async{
    db.transaction((txn) async{
      await txn.delete("Users", where: "email= ?", whereArgs: [email]);
    });
  }

  Future<List> pegarEmail(String email) async{
    return db.rawQuery("SELECT * FROM Users WHERE email=?", [email]);
  }

  Future<bool> checarSenha(String email, String senha) async{
    List query = await db.rawQuery("SELECT hash, salt FROM Users WHERE email=?", [email]);
    String hash = query[0]["hash"];
    String salt = query[0]["salt"];
    String hashSenha = hashGen.generateBase64Key(senha, salt, defaultRounds, 60);
    return hash == hashSenha;
  }

  Future<dynamic> pegarTabelaUsuario() async{
    var query = await db.rawQuery("SELECT * FROM Users");
    return query;
  }

  

}