// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 3;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice()
      ..id = fields[0] as String?
      ..date = fields[1] as DateTime?
      ..quantity = fields[2] as double?
      ..value = fields[3] as double?
      ..credit = fields[4] == null ? false : fields[4] as bool?
      ..paymentType = fields[5] as String?
      ..categoryId = fields[6] as String?
      ..category = fields[10] as Category?
      ..lendingId = fields[7] as String?
      ..updatedAt = fields[8] as DateTime?
      ..sync = fields[9] == null ? false : fields[9] as bool?
      ..remoteId = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.credit)
      ..writeByte(5)
      ..write(obj.paymentType)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.lendingId)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.sync)
      ..writeByte(11)
      ..write(obj.remoteId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
