import 'package:ceeb_mobile/dto/invoice_dto.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;
  final List<Category> categories;
  const InvoiceListItem(this.invoice, this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    final total = invoice.quantity!.toDouble() * invoice.value!.toDouble();
    final text =
        'Valor R\$ ${total.toStringAsFixed(2)} - Data ${DateFormat('dd/MM/yyyy').format(invoice.date ?? DateTime.now())}';

    return ListTile(
      title: Text(invoice.category?.name ?? ''),
      subtitle: Text(text),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                final dto = InvoiceDTO(categories);
                dto.invoice = invoice;
                Navigator.of(context).pushNamed(
                  AppRoutes.invoiceForm,
                  arguments: dto,
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
