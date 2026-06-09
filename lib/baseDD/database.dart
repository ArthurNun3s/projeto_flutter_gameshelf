import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jogo.dart'; // Ajuste este caminho se salvar em pastas diferentes

// Método para criar/acessar a instância do banco de dados
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

// Operação no Banco de Dados: Inserir
Future<int> insert(Jogo jogo) async {
  Database db = await getDatabase();
  Map<String, dynamic> values = jogo.toMap();
  return db.insert("jogos", values);
}

// Operação no Banco de Dados: Buscar Todos
Future<List<Jogo>> findAll() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> listMap = await db.query("jogos");
  List<Jogo> listaJogos = [];

  for (Map<String, dynamic> map in listMap) {
    listaJogos.add(Jogo.fromMap(map));
  }
  return listaJogos;
}

// Operação no Banco de Dados: Atualizar
Future<int> update(Jogo jogo) async {
  Database db = await getDatabase();
  Map<String, dynamic> values = jogo.toMap();
  return db.update("jogos", values, where: 'id = ?', whereArgs: [jogo.id]);
}

// Operação no Banco de Dados: Deletar
Future<int> delete(int id) async {
  Database db = await getDatabase();
  return db.delete("jogos", where: 'id = ?', whereArgs: [id]);
}
