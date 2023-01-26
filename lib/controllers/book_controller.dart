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

  Future<List<Book>> find(String name) async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      return books.values.where((book) {
        if (name.isEmpty) {
          if (book.name!.toLowerCase().contains(name.toLowerCase())) {
            return true;
          }
          if (book.code!.toLowerCase().contains(name.toLowerCase())) {
            return true;
          }
          if (book.edition!.toLowerCase().contains(name.toLowerCase())) {
            return true;
          }
        }
        return false;
      }).toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> persist(Book book) async {
    final books = await Hive.openBox<Book>(TableName.book.name);
    book.id ??= uuid.v4();
    book.updatedAt = DateTime.now();
    book.sync = false;
    await books.put(book.id, book);
  }

  Future<void> updateAvailable(String id, bool borrow) async {
    final booksRecords = await Hive.openBox<Book>(TableName.book.name);
    var book = booksRecords.get(id);
    if (book != null) {
      book.borrow = borrow;
      book.sync = false;
      book.updatedAt = DateTime.now();
      await persist(book);
    }
  }
}
