// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigurationAdapter extends TypeAdapter<Configuration> {
  @override
  final int typeId = 2;

  @override
  Configuration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Configuration()
      ..id = fields[0] as String?
      ..penaltyValue = fields[1] as double?
      ..lendingDays = fields[2] as int?
      ..remoteId = fields[3] as String?
      ..updateAt = fields[4] as DateTime?
      ..sync = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Configuration obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.penaltyValue)
      ..writeByte(2)
      ..write(obj.lendingDays)
      ..writeByte(3)
      ..write(obj.remoteId)
      ..writeByte(4)
      ..write(obj.updateAt)
      ..writeByte(5)
      ..write(obj.sync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
