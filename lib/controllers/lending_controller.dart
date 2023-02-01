import 'package:ceeb_mobile/controllers/book_controller.dart';
import 'package:ceeb_mobile/controllers/reader_controller.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class LendingController {
  final uuid = Uuid();

  Future<List<Lending>> list() async {
    try {
      final lendings = await Hive.openBox<Lending>(TableName.lending.name);
      return lendings.values.toList();
    } catch (e) {
      print(e);
      throw (Exception(e));
    }
  }

  Future<List<Lending>> listForSynchronize() async {
    try {
      final lendings = await Hive.openBox<Lending>(TableName.lending.name);
      return lendings.values.where((lending) => lending.sync == false).toList();
    } catch (e) {
      print(e);
      throw (Exception(e));
    }
  }

  Future<void> persist(Lending lending) async {
    lending.sync = false;
    await persistSync(lending);
  }

  Future<void> persistSync(Lending lending) async {
    final lendings = await Hive.openBox<Lending>(TableName.lending.name);
    lending.id ??= uuid.v4();
    lending.updatedAt = DateTime.now();
    await lendings.put(lending.id, lending);
  }

  Future<void> borrowBook(Lending lending) async {
    await persist(lending);

    final bookController = BookController();
    await bookController.updateAvailable(lending.bookId!, true);

    final readerController = ReaderController();
    await readerController.hasBook(lending.readerId!, true);
  }

  Future<void> returnBook(Lending lending) async {
    lending.deliveryDate = DateTime.now();
    lending.returned = true;
    await persist(lending);

    final bookController = BookController();
    await bookController.updateAvailable(lending.bookId!, false);

    final readerController = ReaderController();
    await readerController.hasBook(lending.readerId!, false);
  }

  Future<void> clear() async {
    final lendings = await Hive.openBox<Lending>(TableName.lending.name);
    await lendings.clear();
    await lendings.flush();
  }

  Future<Lending?> get(String id) async {
    try {
      final lendings = await Hive.openBox<Lending>(TableName.lending.name);
      return lendings.get(id);
    } catch (e) {
      return null;
    }
  }

  Future<Lending?> findByRemoteId(String remoteId) async {
    try {
      final lendings = await Hive.openBox<Lending>(TableName.lending.name);
      return lendings.values
          .firstWhere((element) => element.remoteId == remoteId);
    } catch (e) {
      return null;
    }
  }
}
