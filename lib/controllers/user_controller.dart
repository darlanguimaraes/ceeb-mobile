import 'package:ceeb_mobile/models/user.dart';
import 'package:ceeb_mobile/utils/enum_table_name.dart';
import 'package:hive/hive.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UserController {
  Future<User> login(String username, String password) async {
    try {
      final users = await Hive.openBox<User>(TableName.user.name);
      final user = users.values.firstWhere((element) {
        return element.username == username;
      });
      final hashPassword =
          DBCrypt().hashpw(password, DBCrypt().gensaltWithRounds(8));

      final valid = DBCrypt().checkpw(password, user.password!);
      if (valid) {
        return user;
      }
    } catch (e) {
      print(e);
      throw Exception('User not found');
    }
    throw Exception('User not found');
  }
}
