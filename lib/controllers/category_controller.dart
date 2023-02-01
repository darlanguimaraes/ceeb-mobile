import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:uuid/uuid.dart';

class CategoryController {
  final uuid = Uuid();
  Future<List<Category>> list() async {
    try {
      final categories = await Hive.openBox<Category>(TableName.category.name);
      return categories.values.toList();
    } catch (e) {
      print(e);
      throw (Exception(e));
    }
  }

  Future<void> persist(Category category, bool sync) async {
    final categories = await Hive.openBox<Category>(TableName.category.name);
    category.id ??= uuid.v4();
    category.updatedAt = DateTime.now();
    category.sync = sync;
    await categories.put(category.id, category);
    await categories.flush();
  }

  Future<List<Category>> listForSynchronize() async {
    try {
      final categories = await Hive.openBox<Category>(TableName.category.name);
      return categories.values.where((category) {
        return category.sync == false;
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Category?> findByRemoteId(String id) async {
    try {
      final categories = await Hive.openBox<Category>(TableName.category.name);
      if (categories.values.isNotEmpty) {
        return categories.values
            .firstWhere((element) => element.remoteId == id);
      }
    } catch (e) {
      return null;
    }
  }

  Future<Category?> get(String id) async {
    try {
      final categories = await Hive.openBox<Category>(TableName.category.name);
      return categories.values.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clear() async {
    try {
      final categories = await Hive.openBox<Category>(TableName.category.name);
      await categories.clear();
      await categories.flush();
    } catch (e) {
      throw Exception(e);
    }
  }
}
