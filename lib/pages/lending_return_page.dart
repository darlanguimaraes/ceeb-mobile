import 'package:ceeb_mobile/models/lending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LendingReturnPage extends StatefulWidget {
  const LendingReturnPage({super.key});

  @override
  State<LendingReturnPage> createState() => _LendingReturnPageState();
}

class _LendingReturnPageState extends State<LendingReturnPage> {
  Lending _lending = Lending();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      final lending = arg as Lending;
      _lending = lending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devolução'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Row(
              children: [
                Text('Livro'),
                Text(_lending.bookName!),
              ],
            ),
            Row(
              children: [
                const Text('Leitor'),
                Text(_lending.readerName!),
              ],
            ),
            Row(
              children: [
                const Text('Data de retirada'),
                Text(DateFormat('dd/MM/yyyy')
                    .format(_lending.date ?? DateTime.now())),
              ],
            ),
            Row(
              children: [
                const Text('Data prevista'),
                Text(DateFormat('dd/MM/yyyy')
                    .format(_lending.expectedDate ?? DateTime.now())),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
