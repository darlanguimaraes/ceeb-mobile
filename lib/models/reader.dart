import 'package:hive/hive.dart';

part 'reader.g.dart';

@HiveType(typeId: 5)
class Reader extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? address;

  @HiveField(4)
  String? city;

  @HiveField(5, defaultValue: false)
  bool? sync;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  String? email;

  @HiveField(8, defaultValue: false)
  bool? openLoan;

  @HiveField(9)
  String? remoteId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'email': email,
        "openLoan": openLoan,
        "remoteId": remoteId,
      };
}
