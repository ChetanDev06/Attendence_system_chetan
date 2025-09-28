// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineEventAdapter extends TypeAdapter<OfflineEvent> {
  @override
  final int typeId = 0;

  @override
  OfflineEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineEvent(
      classId: fields[0] as int,
      studentId: fields[1] as int?,
      method: fields[2] as String,
      confidence: fields[3] as double?,
      imagePath: fields[4] as String,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineEvent obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.classId)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.method)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
