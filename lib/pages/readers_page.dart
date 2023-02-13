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
    final deviceSize = MediaQuery.of(context).size;
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.readerForm),
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.add),
          label: const Text('Novo'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: deviceSize.width > 700 ? 700 : double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width:
                        deviceSize.width > 700 ? 500 : deviceSize.width - 150,
                    child: TextField(
                      controller: filterController,
                      decoration: const InputDecoration(labelText: 'Pesquisar'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => setState(
                            () {
                              getList = _loadReaders(context);
                            },
                          ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                      ),
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
      ),
    );
  }
}
