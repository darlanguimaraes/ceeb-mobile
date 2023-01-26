import 'package:ceeb_mobile/models/user.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';

class UserController {
  Future<User> login(String username, String password) async {
    final users = await Hive.openBox(TableName.user.name);
    final filtered = users.values.where((element) {
      return element.username == username && element.password == password;
    }).toList();

    if (filtered.isNotEmpty) {
      final user = filtered[0];
      return user;
    }
    throw Exception('User not found');
  }
}
