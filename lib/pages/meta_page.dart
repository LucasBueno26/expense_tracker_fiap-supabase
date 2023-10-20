import 'package:expense_tracker/components/meta_item.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/pages/meta_cadastro_page.dart';
import 'package:expense_tracker/repository/meta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetaPage extends StatefulWidget {
  const MetaPage({super.key});

  @override
  State<MetaPage> createState() => _MetaPageState();
}

class _MetaPageState extends State<MetaPage> {
  final metaRepo = MetasRepository();
  late Future<List<Meta>> futureMeta;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureMeta = metaRepo.listarMetas(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Metas'),
        ),
        body: FutureBuilder<List<Meta>>(
          future: futureMeta,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Erro ao carregar as metas"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Nenhuma meta cadastrada"),
              );
            } else {
              final metas = snapshot.data!;
              return ListView.separated(
                itemCount: metas.length,
                itemBuilder: (context, index) {
                  final meta = metas[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MetaCadastroPage(
                                  metasParaEdicao: meta,
                                ),
                              ),
                            ) as bool?;

                            if (result == true) {
                              setState(() {
                                futureMeta = metaRepo.listarMetas(
                                  userId: user?.id ?? '',
                                );
                              });
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            await metaRepo.excluirMeta(meta.id);

                            setState(() {
                              metas.removeAt(index);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remover',
                        ),
                      ],
                    ),
                    child: MetaItem(
                      meta: meta,
                      onTap: () {
                        Navigator.pushNamed(context, '/meta-detalhes',
                            arguments: meta);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            }
          },
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "meta-cadastro",
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, '/meta-cadastro') as bool?;

              if (result == true) {
                setState(() {
                  futureMeta = metaRepo.listarMetas(
                    userId: user?.id ?? '',
                  );
                });
              }
            },
            child: const Icon(Icons.add),
          ),
        ]));
  }
}
