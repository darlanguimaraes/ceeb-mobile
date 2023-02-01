import 'package:ceeb_mobile/models/category.dart';
import 'package:hive/hive.dart';

part 'invoice.g.dart';

@HiveType(typeId: 3)
class Invoice extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  double? quantity;

  @HiveField(3)
  double? value;

  @HiveField(4, defaultValue: false)
  bool? credit;

  @HiveField(5)
  String? paymentType;

  @HiveField(6)
  String? categoryId;

  @HiveField(10)
  Category? category;

  @HiveField(7)
  String? lendingId;

  @HiveField(8)
  DateTime? updatedAt;

  @HiveField(9, defaultValue: false)
  bool? sync;

  @HiveField(11)
  String? remoteId;

  Map<String, dynamic> toJson(String remoteCategoryId) => {
        "id": id,
        "date": date!.toIso8601String(),
        "quantity": quantity,
        "value": value,
        "credit": credit,
        "paymentType": paymentType,
        "categoryId": remoteCategoryId,
        "lendingId": lendingId,
        "remoteId": remoteId,
      };
}
