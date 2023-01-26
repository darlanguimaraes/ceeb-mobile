import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class InvoiceController {
  final uuid = Uuid();

  Future<List<Invoice>> list() async {
    try {
      final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
      return invoices.values.toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> persist(Invoice invoice) async {
    final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
    invoice.id ??= uuid.v4();
    invoice.updatedAt = DateTime.now();
    invoice.sync = false;
    await invoices.put(invoice.id, invoice);
  }
}
