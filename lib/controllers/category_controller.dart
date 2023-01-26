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

  Future<void> persist(Category category) async {
    final categories = await Hive.openBox<Category>(TableName.category.name);
    category.id ??= uuid.v4();
    category.updatedAt = DateTime.now();
    category.sync = false;
    await categories.put(category.id, category);
  }
}
