import 'package:ceeb_mobile/components/dialog.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.lending);
    }
  }

  Future<void> _submit() async {
    try {
      await Provider.of<LendingProvider>(context, listen: false)
          .returned(_lending);
      await Dialogs.showMyDialog(context, 'SUCESSO!', 'Devolução executada.');
      Navigator.of(context).pop();
    } catch (e) {
      await Dialogs.showMyDialog(
          context, 'Ocorreu um erro!', 'Não foi possível devolver o livro.');
    }
  }

  Future<void> _renew(BuildContext context) async {
    try {
      DateTime newDeliveryDate =
          _lending.expectedDate!.add(const Duration(days: 30));
      _lending.expectedDate = newDeliveryDate;
      _lending.sync = false;
      await Provider.of<LendingProvider>(context, listen: false)
          .borrow(_lending);
      await Dialogs.showMyDialog(context, 'Livro renovado!',
          'Nova data de entrega: ${DateFormat('dd/MM/yyyy').format(newDeliveryDate)}.');
      Navigator.of(context).pop();
    } catch (e) {
      await Dialogs.showMyDialog(
          context, 'Ocorreu um erro!', 'Não foi possível renovar o livro.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width * 4;

    const styleTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const styleLabel = TextStyle(fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Devolução',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight),
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            children: [
              const Text(
                'Livro',
                style: styleTitle,
              ),
              Text(
                _lending.bookName!,
                style: styleLabel,
              ),
              const Text(
                'Código',
                style: styleTitle,
              ),
              Text(
                _lending.bookCode!,
                style: styleLabel,
              ),
              const Text(
                'Leitor',
                style: styleTitle,
              ),
              Text(
                _lending.readerName!,
                style: styleLabel,
              ),
              const Text(
                'Data de retirada',
                style: styleTitle,
              ),
              Text(
                DateFormat('dd/MM/yyyy')
                    .format(_lending.date ?? DateTime.now()),
                style: styleLabel,
              ),
              const Text(
                'Data de entrega',
                style: styleTitle,
              ),
              Text(
                DateFormat('dd/MM/yyyy')
                    .format(_lending.expectedDate ?? DateTime.now()),
                style: styleLabel,
              ),
              if (_lending.isLate)
                const Text(
                  'Entrega em atrso',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              if (_lending.isLate)
                Text(
                  _lending.lateDays.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!_lending.isLate)
                ElevatedButton(
                  onPressed: () => _renew(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      backgroundColor: Colors.amber),
                  child: const Text('Renovar'),
                ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                ),
                child: const Text('Devolver'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
