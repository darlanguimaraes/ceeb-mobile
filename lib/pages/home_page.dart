import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/lending_list_item.dart';
import 'package:ceeb_mobile/dto/report_lending_dto.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEEB',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<LendingProvider>(context, listen: false).getReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              width: deviceSize.width > 700 ? 700 : double.infinity,
              child: Column(
                children: [
                  Text(
                    'Número de livros emprestados: ${snapshot.data!.totalOpenLendings}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(),
                  Text(
                    'Número de livros em atraso: ${snapshot.data!.totalLateLendings}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(),
                  if (snapshot.data != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.lateLendings.length,
                        itemBuilder: ((ctx, index) => Column(
                              children: [
                                LendingListItem(
                                    snapshot.data!.lateLendings[index], false),
                                const Divider(),
                              ],
                            )),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
