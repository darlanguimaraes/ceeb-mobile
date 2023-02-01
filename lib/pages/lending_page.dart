import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/lending_list_item.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LendingPage extends StatelessWidget {
  const LendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Empréstimos e Devoluções',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.lendingForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<LendingProvider>(context, listen: false).loadLendings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return Consumer<LendingProvider>(
              builder: ((ctx, lending, child) => ListView.builder(
                    itemCount: lending.count,
                    itemBuilder: ((ctx, index) => Column(
                          children: [
                            LendingListItem(lending.lendings[index]),
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
