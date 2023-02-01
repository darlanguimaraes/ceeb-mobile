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
    final configs = await Hive.openBox(TableName.configuration.name);
    if (configs.values.isEmpty) {
      final config = Configuration();
      config.id = uuid.v4();
      config.lendingDays = 30;
      config.penaltyValue = 1;
      config.sync = DateTime.utc(2023, 1, 1, 1, 18, 04);
      config.updateAt = DateTime.now();
      await configs.put(config.id, config);
    }
  }
}
