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
      subtitle: Text('${book.author!} - ${book.code}'),
      leading: SizedBox(
        width: 30,
        child: Row(
          children: [
            book.borrow == true
                ? const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  )
          ],
        ),
      ),
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
