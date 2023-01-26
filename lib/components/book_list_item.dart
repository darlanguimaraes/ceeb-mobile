import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.name.toString()),
      subtitle: Text(book.author.toString()),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.bookForm,
                arguments: book,
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
