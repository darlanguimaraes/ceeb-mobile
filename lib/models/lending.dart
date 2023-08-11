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

  @HiveField(13)
  String? readerName;

  @HiveField(14)
  String? bookName;

  @HiveField(15)
  String? bookCode;

  @HiveField(16)
  String? bookEdition;

  String? readerPhone;

  bool get isLate {
    final DateTime actual = DateTime.now();
    final value = expectedDate!.compareTo(actual);
    return value < 0;
  }

  int get lateDays {
    final DateTime actual = DateTime.now();
    return actual.difference(expectedDate!).inDays;
  }

  Map<String, dynamic> toJson(String remoteBookId, String remoteReaderId) => {
        "id": id,
        "bookId": remoteBookId,
        "readerId": remoteReaderId,
        "date": date != null ? date!.toIso8601String() : null,
        "expectedDate":
            expectedDate != null ? expectedDate!.toIso8601String() : null,
        "deliveryDate":
            deliveryDate != null ? deliveryDate!.toIso8601String() : null,
        "code": code,
        "returned": returned,
        "remoteId": remoteId,
      };
}
