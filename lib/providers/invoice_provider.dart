import 'package:ceeb_mobile/controllers/invoice_controller.dart';
import 'package:ceeb_mobile/models/invoice.dart';
import 'package:flutter/material.dart';

class InvoiceProvider with ChangeNotifier {
  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => [..._invoices];
  int get count => _invoices.length;

  Future<void> loadInvoices() async {
    _invoices.clear();

    final invoiceController = InvoiceController();
    final invoices = await invoiceController.list();
    invoices.sort((a, b) => a.date!.compareTo(b.date!));
    _invoices.addAll(invoices);

    notifyListeners();
  }

  Future<void> persist(Invoice invoice) async {
    final invoiceController = InvoiceController();
    await invoiceController.persist(invoice);
    await loadInvoices();
  }
}
