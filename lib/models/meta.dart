import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/conta.dart';

class Meta {
  int id;
  String userId;
  String nome;
  double valor;
  double newvalor;
  Categoria categoria;
  Conta conta;

  Meta({
    required this.id,
    required this.userId,
    required this.nome,
    required this.valor,
    required this.newvalor,
    required this.categoria,
    required this.conta,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'],
      userId: map['user_id'],
      nome: map['nome'],
      valor: map['valor'],
      newvalor: map['newvalor'],
      categoria: Categoria.fromMap(map['categorias']),
      conta: Conta.fromMap(map['contas']),
    );
  }
}
