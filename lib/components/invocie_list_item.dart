import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;
  const InvoiceListItem(this.invoice, {super.key});

  @override
  Widget build(BuildContext context) {
    final text =
        'Valor R\$ ${(invoice.quantity ?? 0 * (invoice.value ?? 0)).toStringAsFixed(2)} - Data ${DateFormat('dd/MM/yyyy').format(invoice.date ?? DateTime.now())}';

    return ListTile(
      title: Text(invoice.category?.name ?? ''),
      subtitle: Text(text),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.invoiceForm,
                arguments: invoice,
              ),
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
