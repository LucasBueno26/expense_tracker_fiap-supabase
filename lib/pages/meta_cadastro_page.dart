import 'package:expense_tracker/components/categoria_select.dart';
import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/pages/categorias_select_page.dart';
import 'package:expense_tracker/pages/contas_select_page.dart';
import 'package:expense_tracker/repository/meta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/conta_select.dart';
import '../models/conta.dart';

class MetaCadastroPage extends StatefulWidget {
  final Meta? metasParaEdicao;

  const MetaCadastroPage({super.key, this.metasParaEdicao});

  @override
  State<MetaCadastroPage> createState() => _MetaCadastroPageState();
}

class _MetaCadastroPageState extends State<MetaCadastroPage> {
  User? user;
  final metasRepo = MetasRepository();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Meta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNome(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildCategoriaSelect(),
                const SizedBox(height: 30),
                _buildContaSelect(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CategoriaSelect _buildCategoriaSelect() {
    return CategoriaSelect(
      categoria: categoriaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoriesSelectPage(
              tipoTransacao: TipoTransacao.despesa,
            ),
          ),
        ) as Categoria?;

        if (result != null) {
          setState(() {
            categoriaSelecionada = result;
          });
        }
      },
    );
  }

  ContaSelect _buildContaSelect() {
    return ContaSelect(
      conta: contaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ContasSelectPage(),
          ),
        ) as Conta?;

        if (result != null) {
          setState(() {
            contaSelecionada = result;
          });
        }
      },
    );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe o nome',
        labelText: 'Nome da Meta',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um nome para a meta';
        }
        if (value.length < 2 || value.length > 30) {
          return 'A Descrição deve entre 3  e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor da Meta',
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

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Descricao
            final nome = nomeController.text;
            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));
            // Detalhes
            final userId = user?.id ?? '';

            final meta = Meta(
              id: 0,
              userId: userId,
              nome: nome,
              valor: valor.toDouble(),
              newvalor: NumberFormat.currency(locale: 'pt_BR')
                  .parse(('0'))
                  .toDouble(),
              categoria: categoriaSelecionada!,
              conta: contaSelecionada!,
            );

            if (widget.metasParaEdicao == null) {
              await _cadastrarMeta(meta);
            } else {
              meta.id = widget.metasParaEdicao!.id;
              await _alterarMeta(meta);
            }
          }
        },
        child: const Text('Criar Meta'),
      ),
    );
  }

  Future<void> _cadastrarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metasRepo.cadastrarMeta(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Meta cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      print(error);
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao cadastrar Meta',
        ),
      ));
      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metasRepo.alterarMeta(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Meta alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar Meta',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
