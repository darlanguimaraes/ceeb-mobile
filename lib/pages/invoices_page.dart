import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/invoice_list_item.dart';
import 'package:ceeb_mobile/dto/invoice_dto.dart';
import 'package:ceeb_mobile/providers/category_provider.dart';
import 'package:ceeb_mobile/providers/invoice_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Future<void> load() async {
      Provider.of<InvoiceProvider>(context, listen: false).loadInvoices();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contas',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final invoiceDTO = InvoiceDTO(
                  Provider.of<CategoryProvider>(context, listen: false)
                      .categories);
              Navigator.of(context).pushNamed(
                AppRoutes.invoiceForm,
                arguments: invoiceDTO,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: deviceSize.width > 700 ? 700 : double.infinity,
          child: FutureBuilder(
            future: load(),
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
                                InvoiceListItem(
                                    invoice.invoices[index],
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .categories),
                                const Divider(),
                              ],
                            )),
                      )),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
