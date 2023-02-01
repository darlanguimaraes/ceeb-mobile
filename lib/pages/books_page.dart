import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/book_list_item.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  Future<void> _loadBooks(BuildContext context) =>
      Provider.of<BookProvider>(context, listen: false)
          .loadBooksFilter(filterController.text);

  Future? getList;
  var filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getList = _loadBooks(context);
  }

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Livros',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.bookForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                        controller: filterController,
                        decoration:
                            const InputDecoration(labelText: 'Pesquisar')),
                  ),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            getList = _loadBooks(context);
                          }),
                      child: const Text('filtrar')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: getList,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
