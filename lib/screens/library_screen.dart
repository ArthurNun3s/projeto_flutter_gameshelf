import 'package:flutter/material.dart';
import '../baseDD/database.dart'; // Caminho do seu banco de dados
import '../models/jogo.dart'; // Caminho da sua classe Jogo

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Lista que vai guardar os jogos vindos do banco
  List<Jogo> meusJogos = [];

  @override
  void initState() {
    super.initState();
    // Assim que a tela abrir, ele busca os jogos salvos
    _atualizarLista();
  }

  // Função para buscar no banco e atualizar a tela usando setState
  void _atualizarLista() async {
    List<Jogo> jogosDoBanco = await findAll();

    // O setState forçará a tela a ser desenhada novamente com a nova lista
    setState(() {
      meusJogos = jogosDoBanco;
    });
  }

  // Função para abrir a janela pop-up (formulário)
  void _mostrarFormularioNovoJogo(BuildContext context) {
    TextEditingController tituloController = TextEditingController();
    TextEditingController plataformaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Novo Jogo na Estante"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: "Título do Jogo"),
              ),
              TextField(
                controller: plataformaController,
                decoration:
                    InputDecoration(labelText: "Plataforma (ex: PC, PS5)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Fecha a janela sem salvar
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                // 1. Cria o objeto Jogo com o que foi digitado
                Jogo novoJogo = Jogo(
                  titulo: tituloController.text,
                  plataforma: plataformaController.text,
                  status: "Na Fila",
                  nota: 0,
                );

                // 2. Salva no banco de dados
                await insert(novoJogo);

                // 3. Fecha o pop-up (formulário) retornando para a estante
                Navigator.pop(context);

                // 4. Aciona a atualização da lista para exibir o novo jogo na tela
                _atualizarLista();
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Estante"),
      ),
      // Verificamos se a lista está vazia
      body: meusJogos.isEmpty
          ? Center(
              child: Text(
                "Nenhum jogo na estante ainda.\nClique no + para adicionar!",
                textAlign: TextAlign.center,
              ),
            )
          // Se não estiver vazia, mostramos a lista rolável (ListView)
          : ListView.builder(
              itemCount: meusJogos.length,
              itemBuilder: (context, index) {
                Jogo jogo = meusJogos[index];
                return Card(
                  child: ListTile(
                    title: Text(jogo.titulo,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Plataforma: ${jogo.plataforma} | Status: ${jogo.status}"),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _mostrarFormularioNovoJogo(context);
        },
      ),
    );
  }
}
