import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 6)
class User extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? username;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? password;

  @HiveField(5)
  String? token;

  @HiveField(6)
  String? remoteId;

  @HiveField(7)
  DateTime? updateAt;

  @HiveField(8, defaultValue: false)
  bool? sync;
}
