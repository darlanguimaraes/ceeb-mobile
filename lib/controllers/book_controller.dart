import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:ceeb_mobile/utils/string_utils.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class BookController {
  final uuid = Uuid();
  Future<List<Book>> list() async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      final listBooks = books.values.toList();
      listBooks.sort((a, b) => a.name!.compareTo(b.name!));
      return listBooks;
    } catch (e) {
      print(e);
      throw (Exception(e));
    }
  }

  Future<List<Book>> find(String? text) async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      if (text == null || text.isEmpty) {
        return await list();
      }
      final name = StringUtils.removeDiacritics(text);

      final filtered = books.values.where((book) {
        if (name.isNotEmpty) {
          if (StringUtils.removeDiacritics(book.name!)
              .toLowerCase()
              .contains(name.toLowerCase())) {
            return true;
          }
          if (book.code!.toLowerCase().contains(name.toLowerCase())) {
            return true;
          }
          if (book.edition != null &&
              book.edition!.toLowerCase().contains(name.toLowerCase())) {
            return true;
          }
        }
        return false;
      }).toList();
      filtered.sort((a, b) => a.name!.compareTo(b.name!));
      return filtered;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Book?> getBook(String id) async {
    final books = await Hive.openBox<Book>(TableName.book.name);
    return books.get(id);
  }

  Future<Book?> findByRemoteId(String remoteId) async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      final book =
          books.values.firstWhere((element) => element.remoteId == remoteId);
      return book;
    } catch (e) {
      return null;
    }
  }

  Future<void> persist(Book book) async {
    book.sync = false;
    await persistSync(book);
  }

  Future<void> persistSync(Book book) async {
    final books = await Hive.openBox<Book>(TableName.book.name);
    book.id ??= uuid.v4();
    book.updatedAt = DateTime.now();
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

  Future<void> clear() async {
    final books = await Hive.openBox<Book>(TableName.book.name);
    await books.clear();
    await books.flush();
  }

  Future<List<Book>> listForSynchronize() async {
    try {
      final books = await Hive.openBox<Book>(TableName.book.name);
      return books.values.where((book) => book.sync == false).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
