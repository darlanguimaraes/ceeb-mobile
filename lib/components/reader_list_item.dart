import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ReaderListItem extends StatelessWidget {
  final Reader reader;

  const ReaderListItem(this.reader, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reader.name.toString()),
      subtitle: Text(reader.phone?.toString() ?? ''),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.readerForm,
                arguments: reader,
              ),
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
