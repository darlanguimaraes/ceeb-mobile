import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/models/configuration.dart';
import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/models/user.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class HiveUtils {
  final uuid = Uuid();

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ConfigurationAdapter());
    Hive.registerAdapter(InvoiceAdapter());
    Hive.registerAdapter(LendingAdapter());
    Hive.registerAdapter(ReaderAdapter());
    Hive.registerAdapter(BookAdapter());

    await _initializeUser();
  }

  Future<void> _initializeUser() async {
    final users = await Hive.openBox(TableName.user.name);
    if (users.values.isEmpty) {
      final user = User();
      user.id = uuid.v4();
      user.token = 'abcdef';
      user.name = 'user';
      user.username = 'user';
      user.email = 'user@email.com';
      user.password = '123456';
      user.updateAt = DateTime.now();
      await users.put(user.id, user);
    }
  }
}
