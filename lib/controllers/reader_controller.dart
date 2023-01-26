import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ReaderController {
  final uuid = Uuid();

  Future<List<Reader>> list() async {
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      return readers.values.toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Reader>> find(String name) async {
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      print('aqui');
      return readers.values
          .where((reader) =>
              reader.name!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> persist(Reader reader) async {
    final readers = await Hive.openBox<Reader>(TableName.reader.name);
    reader.id ??= uuid.v4();
    reader.updatedAt = DateTime.now();
    reader.sync = false;
    await readers.put(reader.id, reader);
  }

  Future<void> hasBook(String id, bool openLoan) async {
    final readers = await Hive.openBox<Reader>(TableName.reader.name);
    var reader = readers.get(id);
    if (reader != null) {
      reader.openLoan = openLoan;
      reader.sync = false;
      reader.updatedAt = DateTime.now();
      await persist(reader);
    }
  }
}
