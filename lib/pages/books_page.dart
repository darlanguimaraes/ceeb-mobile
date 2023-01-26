import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/book_list_item.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.bookForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<BookProvider>(context, listen: false).loadBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return Consumer<BookProvider>(
              builder: ((ctx, values, child) => ListView.builder(
                    itemCount: values.count,
                    itemBuilder: ((ctx, index) => Column(
                          children: [
                            BookListItem(values.books[index]),
                            const Divider(),
                          ],
                        )),
                  )),
            );
          }
        },
      ),
    );
  }
}
