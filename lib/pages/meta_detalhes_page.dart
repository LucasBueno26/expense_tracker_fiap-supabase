import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaDetalhesPage extends StatefulWidget {
  const MetaDetalhesPage({super.key});

  @override
  State<MetaDetalhesPage> createState() => _MetaDetalhesPageState();
}

class _MetaDetalhesPageState extends State<MetaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final meta = ModalRoute.of(context)!.settings.arguments as Meta;

    return Scaffold(
      appBar: AppBar(
        title: Text(meta.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(meta.nome.isEmpty ? '-' : meta.nome),
            ),
            ListTile(
              title: const Text('Valor Total da Meta'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(meta.valor)),
            ),
            ListTile(
              title: const Text('Valor Atual Arrecadado'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(meta.newvalor)),
            ),
            ListTile(
              title: const Text('Valor Pendente'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format((meta.valor - meta.newvalor))),
            ),
            ListTile(
              title: const Text('Categoria da Meta'),
              subtitle: Text(meta.categoria.descricao),
            ),
            ContaItem(conta: meta.conta),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "meta-adicionar",
        onPressed: () async {
          try {
            final result = await Navigator.pushNamed(context, '/meta-adicionar',
                arguments: meta);
            if (result == true) {
              setState(() {});
            } else {
              print('Ocorreu um erro ou a operação foi cancelada.');
            }
          } catch (e) {
            print('Erro: $e');
          }
        },
        child: const Text('R\$'),
      ),
    );
  }
}
