import 'package:expense_tracker/models/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetasRepository {
  Future<List<Meta>> listarMetas({required String userId}) async {
    final supabase = Supabase.instance.client;

    var query = supabase.from('meta').select<List<Map<String, dynamic>>>('''
            *,
            categorias (
              *
            ),
            contas (
              *
            )
            ''').eq('user_id', userId);

    var data = await query;

    final list = data.map((map) {
      return Meta.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('meta').insert({
      'nome': meta.nome,
      'user_id': meta.userId,
      'newvalor': meta.newvalor,
      'valor': meta.valor,
      'categoria_id': meta.categoria.id,
      'conta_id': meta.conta.id,
    });
  }

  Future adicionarValor(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('meta').update({
      'newvalor': meta.newvalor,
    }).match({'id': meta.id});
  }

  Future alterarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('meta').update({
      'nome': meta.nome,
      'user_id': meta.userId,
      'valor': meta.valor,
      'newvalor': meta.newvalor,
      'categoria_id': meta.categoria.id,
      'conta_id': meta.conta.id,
    }).match({'id': meta.id});
  }

  Future excluirMeta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('meta').delete().match({'id': id});
  }
}
