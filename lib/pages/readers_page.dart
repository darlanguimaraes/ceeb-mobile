import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/reader_list_item.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadersPage extends StatelessWidget {
  const ReadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitores'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.readerForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<ReaderProvider>(context, listen: false).loadReaders(),
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
    );
  }
}
