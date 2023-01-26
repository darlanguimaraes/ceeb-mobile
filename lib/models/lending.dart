import 'package:hive/hive.dart';

part 'lending.g.dart';

@HiveType(typeId: 4)
class Lending extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? bookId;

  @HiveField(2)
  String? readerId;

  @HiveField(3)
  DateTime? date;

  @HiveField(4)
  DateTime? expectedDate;

  @HiveField(5)
  DateTime? deliveryDate;

  @HiveField(6)
  String? code;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(8, defaultValue: false)
  bool? returned;

  @HiveField(9, defaultValue: false)
  bool? sync;

  @HiveField(10)
  String? remoteId;
}
