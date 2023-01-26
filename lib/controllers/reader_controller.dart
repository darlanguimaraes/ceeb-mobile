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

  Future<void> persist(Reader reader) async {
    final categories = await Hive.openBox<Reader>(TableName.reader.name);
    reader.id ??= uuid.v4();
    reader.updatedAt = DateTime.now();
    reader.sync = false;
    await categories.put(reader.id, reader);
  }
}
