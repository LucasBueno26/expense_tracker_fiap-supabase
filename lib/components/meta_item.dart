import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaItem extends StatelessWidget {
  final Meta meta;
  final void Function()? onTap;

  const MetaItem({Key? key, required this.meta, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: meta.categoria.cor,
        child: Icon(
          meta.categoria.icone,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(meta.nome),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.push_pin,
            size: 16,
            color: Color.fromARGB(255, 255, 4, 0),
          ),
          SizedBox(width: 6),
          Text(
            NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.swap_vert,
            size: 20,
            color: Colors.green,
          ),
          SizedBox(width: 6),
          Text(
            NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.newvalor),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
