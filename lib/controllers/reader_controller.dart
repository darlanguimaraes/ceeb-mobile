import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ReaderController {
  final uuid = Uuid();

  Future<List<Reader>> list() async {
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      final listReaders = readers.values.toList();
      listReaders.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return listReaders;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Reader>> find(String? name) async {
    if (name == null || name.isEmpty) {
      return list();
    }
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      final listReaders = readers.values
          .where((reader) =>
              reader.name!.toLowerCase().contains(name.toLowerCase()))
          .toList();
      listReaders.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return listReaders;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> persist(Reader reader) async {
    reader.sync = false;
    await persistSync(reader);
  }

  Future<void> persistSync(Reader reader) async {
    final readers = await Hive.openBox<Reader>(TableName.reader.name);
    reader.id ??= uuid.v4();
    reader.updatedAt = DateTime.now();
    await readers.put(reader.id, reader);
  }

  Future<void> clear() async {
    final readers = await Hive.openBox<Reader>(TableName.reader.name);
    await readers.clear();
    await readers.flush();
  }

  Future<Reader?> findByRemoteId(String id) async {
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      return readers.values.firstWhere((element) => element.remoteId == id);
    } catch (e) {
      return null;
    }
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

  Future<List<Reader>> listForSynchronize() async {
    try {
      final readers = await Hive.openBox<Reader>(TableName.reader.name);
      return readers.values.where((reader) => reader.sync == false).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Reader?> getReader(String id) async {
    final readers = await Hive.openBox<Reader>(TableName.reader.name);
    return readers.get(id);
  }
}
