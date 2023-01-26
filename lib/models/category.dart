import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? remoteId;

  @HiveField(3, defaultValue: false)
  bool? sync;

  @HiveField(4)
  DateTime? updatedAt;
}
