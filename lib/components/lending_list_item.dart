import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LendingListItem extends StatelessWidget {
  final Lending lending;
  final bool showTrailing;

  const LendingListItem(this.lending, this.showTrailing, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('${lending.bookName} - ${lending.bookCode}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${lending.readerName}'),
            Text('Telefone: ${lending.readerPhone}'),
            Text(
                'Data de entrega: ${DateFormat('dd/MM/yyyy').format(lending.expectedDate ?? DateTime.now())}'),
          ],
        ),
        leading: SizedBox(
          width: 40,
          child: Row(
            children: [
              lending.returned == true
                  ? const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 35,
                    )
                  : Icon(
                      Icons.error_outline,
                      color: lending.isLate ? Colors.red : Colors.amber,
                      size: 35,
                    ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: [
              lending.returned == true
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 35,
                    )
                  : IconButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.lendingReturn,
                        arguments: lending,
                      ),
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 35,
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
            ],
          ),
        ));
  }
}
