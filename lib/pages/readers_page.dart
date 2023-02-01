import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/reader_list_item.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadersPage extends StatefulWidget {
  const ReadersPage({super.key});

  @override
  State<ReadersPage> createState() => _ReadersPageState();
}

class _ReadersPageState extends State<ReadersPage> {
  Future<void> _loadReaders(BuildContext context) =>
      Provider.of<ReaderProvider>(context, listen: false)
          .loadReadersFilter(filterController.text);

  Future? getList;
  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getList = _loadReaders(context);
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
          'Leitores',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.readerForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: filterController,
                    decoration: const InputDecoration(labelText: 'Pesquisar'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => setState(() {
                          getList = _loadReaders(context);
                        }),
                    child: const Text('Pesquisar'))
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
                    return Consumer<ReaderProvider>(
                      builder: ((ctx, readers, child) => ListView.builder(
                            itemCount: readers.count,
                            itemBuilder: ((ctx, index) => Column(
                                  children: [
                                    ReaderListItem(readers.readers[index]),
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
    );
  }
}
