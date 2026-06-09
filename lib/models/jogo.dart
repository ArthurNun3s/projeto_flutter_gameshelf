class Jogo {
  int? id;
  String titulo;
  String plataforma;
  String status;
  int nota;

  Jogo(
      {this.id,
      required this.titulo,
      required this.plataforma,
      required this.status,
      required this.nota});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'plataforma': plataforma,
      'status': status,
      'nota': nota,
    };
  }

  factory Jogo.fromMap(Map<String, dynamic> map) {
    return Jogo(
      id: map['id'],
      titulo: map['titulo'],
      plataforma: map['plataforma'],
      status: map['status'],
      nota: map['nota'],
    );
  }
}
