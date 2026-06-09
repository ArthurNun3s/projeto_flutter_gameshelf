import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../baseDD/database.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Instância do banco de dados
  final DatabaseHelper dbHelper = DatabaseHelper();
  
  // Controladores para capturar o que o usuário digita
  final TextEditingController controladorTitulo = TextEditingController();
  final TextEditingController controladorPlataforma = TextEditingController();
  final TextEditingController controladorStatus = TextEditingController();
  final TextEditingController controladorNota = TextEditingController();

  // Função que mostra a janelinha (pop-up) do formulário
  void _mostrarFormulario() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Novo Jogo"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controladorTitulo,
                  decoration: InputDecoration(labelText: "Título do Jogo"),
                ),
                TextField(
                  controller: controladorPlataforma,
                  decoration: InputDecoration(labelText: "Plataforma (ex: PC, PS5)"),
                ),
                TextField(
                  controller: controladorStatus,
                  decoration: InputDecoration(labelText: "Status (ex: Jogando, Zerado)"),
                ),
                TextField(
                  controller: controladorNota,
                  decoration: InputDecoration(labelText: "Nota (0 a 10)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Fecha a janela se cancelar
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Monta o jogo com os dados digitados
                Jogo novoJogo = Jogo(
                  titulo: controladorTitulo.text,
                  plataforma: controladorPlataforma.text,
                  status: controladorStatus.text,
                  nota: int.tryParse(controladorNota.text) ?? 0,
                );

                // Salva no banco de dados esperando a conclusão
                await dbHelper.insertJogo(novoJogo);
                
                // Limpa os campos para o próximo cadastro
                controladorTitulo.clear();
                controladorPlataforma.clear();
                controladorStatus.clear();
                controladorNota.clear();

                // Fecha a janelinha do formulário
                Navigator.pop(context);
                
                // Atualiza a tela para mostrar o jogo recém-adicionado
                setState(() {}); 
              },
              child: Text("Salvar"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minha Estante")),
      
      // O FutureBuilder busca a lista de jogos salva no SQLite automaticamente
      body: FutureBuilder<List<Jogo>>(
        future: dbHelper.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Carregando
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Sua estante está vazia. Adicione um jogo!"));
          }
          
          // Desenha a lista de jogos salvos
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Jogo jogo = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(jogo.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${jogo.plataforma} • ${jogo.status}"),
                  trailing: Text("Nota: ${jogo.nota}/10", style: TextStyle(fontSize: 14)),
                ),
              );
            },
          );
        },
      ),
      
      // Botão flutuante de + que chama a função de mostrar o formulário
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: Icon(Icons.add),
      ),
    );
  }
}