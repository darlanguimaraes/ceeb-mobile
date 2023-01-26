import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BookController {
  final uuid = Uuid();
  Future<List<Book>> list() async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      return books.values.toList();
    } catch (e) {
      print(e);
      throw (Exception(e));
    }
  }

  Future<void> persist(Book book) async {
    final books = await Hive.openBox<Book>(TableName.book.name);
    book.id ??= uuid.v4();
    book.updatedAt = DateTime.now();
    book.sync = false;
    await books.put(book.id, book);
  }
}
