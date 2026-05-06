part of 'incident.dart';

class IncidentAdapter extends TypeAdapter<Incident> {
  @override
  final int typeId = 0;

  @override
  Incident read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Incident(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      categoryIndex: fields[3] as int,
      priorityIndex: fields[4] as int,
      statusIndex: fields[5] as int?,
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      location: fields[8] as String,
      reportedTime: fields[9] as DateTime?,
      assignedResponder: fields[10] as String?,
      isSynced: fields[11] as bool?,
      resolvedTime: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Incident obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.reportedTime)
      ..writeByte(10)
      ..write(obj.assignedResponder)
      ..writeByte(11)
      ..write(obj.isSynced)
      ..writeByte(12)
      ..write(obj.resolvedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}