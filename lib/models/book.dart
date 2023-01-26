import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 7)
class Book extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? author;

  @HiveField(3)
  String? writer;

  @HiveField(4)
  String? code;

  @HiveField(5, defaultValue: false)
  bool? borrow;

  @HiveField(6, defaultValue: false)
  bool? sync;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(9)
  String? edition;

  @HiveField(10)
  String? remoteId;
}
