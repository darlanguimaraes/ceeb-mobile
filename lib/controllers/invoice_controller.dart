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

  Future<List<Invoice>> listForSynchronize() async {
    try {
      final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
      return invoices.values.where((invoice) => invoice.sync == false).toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> persist(Invoice invoice) async {
    invoice.sync = false;
    await persistSync(invoice);
  }

  Future<Invoice?> findByRemoteId(String remoteId) async {
    try {
      final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
      return invoices.values
          .firstWhere((element) => element.remoteId == remoteId);
    } catch (e) {
      return null;
    }
  }

  Future<Invoice?> get(String id) async {
    try {
      final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
      return invoices.get(id);
    } catch (e) {
      return null;
    }
  }

  Future<void> persistSync(Invoice invoice) async {
    final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
    invoice.id ??= uuid.v4();
    invoice.updatedAt = DateTime.now();
    await invoices.put(invoice.id, invoice);
  }

  Future<void> clear() async {
    final invoices = await Hive.openBox<Invoice>(TableName.invoice.name);
    await invoices.clear();
    await invoices.flush();
  }
}
