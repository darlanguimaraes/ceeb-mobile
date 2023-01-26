// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 7;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book()
      ..id = fields[0] as String?
      ..name = fields[1] as String?
      ..author = fields[2] as String?
      ..writer = fields[3] as String?
      ..code = fields[4] as String?
      ..borrow = fields[5] == null ? false : fields[5] as bool?
      ..sync = fields[6] == null ? false : fields[6] as bool?
      ..updatedAt = fields[7] as DateTime?
      ..edition = fields[9] as String?
      ..remoteId = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.writer)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.borrow)
      ..writeByte(6)
      ..write(obj.sync)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.edition)
      ..writeByte(10)
      ..write(obj.remoteId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
