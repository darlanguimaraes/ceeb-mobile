import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LendingListItem extends StatelessWidget {
  final Lending lending;

  const LendingListItem(this.lending, {super.key});

  @override
  Widget build(BuildContext context) {
    print(lending.bookName);
    final text =
        '${lending.readerName} - Data de entrega: ${DateFormat('dd/MM/yyyy').format(lending.expectedDate ?? DateTime.now())}';

    return ListTile(
      title: Text('${lending.bookName} - ${lending.bookCode}'),
      subtitle: Text(text),
      leading: SizedBox(
        width: 40,
        child: Row(
          children: [
            Icon(lending.returned!
                ? Icons.check_circle_outline
                : Icons.error_outline)
          ],
        ),
      ),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.lendingForm,
                arguments: lending,
              ),
              icon: const Icon(Icons.arrow_circle_left_outlined),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
