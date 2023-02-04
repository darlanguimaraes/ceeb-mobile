import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/lending_list_item.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LendingPage extends StatefulWidget {
  const LendingPage({super.key});

  @override
  State<LendingPage> createState() => _LendingPageState();
}

class _LendingPageState extends State<LendingPage> {
  bool open = false;

  Future<void> _loadLendings(BuildContext context) =>
      Provider.of<LendingProvider>(context, listen: false)
          .loadLendingsFilter(open);

  Future? getList;

  @override
  void initState() {
    super.initState();
    getList = _loadLendings(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: deviceSize.width > 700 ? 700 : double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Em aberto',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: open,
                    onChanged: (value) {
                      setState(() {
                        open = value;
                        getList = _loadLendings(context);
                      });
                    },
                  )
                ],
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder(
                  future: getList,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
