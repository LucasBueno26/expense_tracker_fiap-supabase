import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:expense_tracker/repository/meta_repository.dart';
import 'package:expense_tracker/repository/transacoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conta.dart';

class MetaAdicionarPage extends StatefulWidget {
  final Meta? metasParaEdicao;

  const MetaAdicionarPage({super.key, this.metasParaEdicao});

  @override
  State<MetaAdicionarPage> createState() => _MetaAdicionarPageState();
}

class _MetaAdicionarPageState extends State<MetaAdicionarPage> {
  User? user;
  final metasRepo = MetasRepository();
  final transRetpo = TransacoesReepository();
  final nomeController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final _formKey = GlobalKey<FormState>();

  Categoria? categoriaSelecionada;
  Conta? contaSelecionada;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final meta = widget.metasParaEdicao;

    if (meta != null) {
      categoriaSelecionada = meta.categoria;
      contaSelecionada = meta.conta;

      nomeController.text = meta.nome;

      valorController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meta = ModalRoute.of(context)!.settings.arguments as Meta;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Valor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildValor(),
                const SizedBox(height: 30),
                _buildButton(meta),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  SizedBox _buildButton(Meta mt) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));
            final userId = user?.id ?? '';

            final meta = Meta(
              id: mt.id,
              userId: userId,
              nome: mt.nome,
              valor: mt.valor.toDouble(),
              newvalor: mt.newvalor + valor.toDouble(),
              categoria: mt.categoria,
              conta: mt.conta,
            );
            final trans = Transacao(
                id: mt.id,
                userId: userId,
                descricao: 'Valor adicionada a Meta: ${mt.nome}',
                tipoTransacao: TipoTransacao.despesa,
                valor: valor.toDouble(),
                data: DateTime.now().toLocal(),
                categoria: mt.categoria,
                conta: mt.conta);
            await transRetpo.cadastrarTransacao(trans);
            await _alterarMeta(meta);
            setState(() {});
          }
        },
        child: const Text('Adicionar na Meta'),
      ),
    );
  }

  Future<void> _alterarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metasRepo.alterarMeta(meta).then((_) {
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Dinheiro adicionado a meta com sucesso',
        ),
      ));

      Navigator.of(context).pop(true);
    }).catchError((error) {
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao adicionar dinheiro a Meta',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
