import 'package:hive/hive.dart';

part 'configuration.g.dart';

@HiveType(typeId: 2)
class Configuration extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double? penaltyValue;

  @HiveField(2)
  int? lendingDays;

  @HiveField(3)
  String? remoteId;

  @HiveField(4)
  DateTime? updateAt;

  @HiveField(5)
  DateTime? sync;
}
