// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReaderAdapter extends TypeAdapter<Reader> {
  @override
  final int typeId = 5;

  @override
  Reader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reader()
      ..id = fields[0] as String?
      ..name = fields[1] as String?
      ..phone = fields[2] as String?
      ..address = fields[3] as String?
      ..city = fields[4] as String?
      ..sync = fields[5] == null ? false : fields[5] as bool?
      ..updatedAt = fields[6] as DateTime?
      ..email = fields[7] as String?
      ..openLoan = fields[8] == null ? false : fields[8] as bool?
      ..remoteId = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, Reader obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.sync)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.openLoan)
      ..writeByte(9)
      ..write(obj.remoteId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
