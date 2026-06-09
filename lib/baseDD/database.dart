import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jogo.dart'; // Aponta para a pasta models que você criou

class DatabaseHelper {
  Future<Database> getDatabase() {
    return getDatabasesPath().then((dbPath) {
      final String path = join(dbPath, "gameshelf.db");
      return openDatabase(path, onCreate: (db, version) {
        db.execute("CREATE TABLE jogos("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "titulo TEXT, "
            "plataforma TEXT, "
            "status TEXT, "
            "nota INTEGER)");
      }, version: 1);
    });
  }

  Future<int> insertJogo(Jogo jogo) async {
    Database db = await getDatabase();
    Map<String, dynamic> values = Map();
    values["titulo"] = jogo.titulo;
    values["plataforma"] = jogo.plataforma;
    values["status"] = jogo.status;
    values["nota"] = jogo.nota;
    return db.insert("jogos", values);
  }

  Future<List<Jogo>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> listMap = await db.query("jogos");
    List<Jogo> listaJogos = [];
    for (Map<String, dynamic> map in listMap) {
      Jogo novoJogo = Jogo(
        id: map["id"],
        titulo: map["titulo"],
        plataforma: map["plataforma"],
        status: map["status"],
        nota: map["nota"]
      );
      listaJogos.add(novoJogo);
    }
    return listaJogos;
  }
}