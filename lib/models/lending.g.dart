// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LendingAdapter extends TypeAdapter<Lending> {
  @override
  final int typeId = 4;

  @override
  Lending read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lending()
      ..id = fields[0] as String?
      ..bookId = fields[1] as String?
      ..readerId = fields[2] as String?
      ..date = fields[3] as DateTime?
      ..expectedDate = fields[4] as DateTime?
      ..deliveryDate = fields[5] as DateTime?
      ..code = fields[6] as String?
      ..updatedAt = fields[7] as DateTime?
      ..returned = fields[8] == null ? false : fields[8] as bool?
      ..sync = fields[9] == null ? false : fields[9] as bool?
      ..remoteId = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, Lending obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.readerId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.expectedDate)
      ..writeByte(5)
      ..write(obj.deliveryDate)
      ..writeByte(6)
      ..write(obj.code)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.returned)
      ..writeByte(9)
      ..write(obj.sync)
      ..writeByte(10)
      ..write(obj.remoteId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LendingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
