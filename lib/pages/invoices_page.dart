import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/invocie_list_item.dart';
import 'package:ceeb_mobile/providers/invoice_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.invoiceForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<InvoiceProvider>(context, listen: false).loadInvoices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return Consumer<InvoiceProvider>(
              builder: ((ctx, invoice, child) => ListView.builder(
                    itemCount: invoice.count,
                    itemBuilder: ((ctx, index) => Column(
                          children: [
                            InvoiceListItem(invoice.invoices[index]),
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
