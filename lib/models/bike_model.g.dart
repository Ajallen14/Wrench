// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaintenanceTaskAdapter extends TypeAdapter<MaintenanceTask> {
  @override
  final int typeId = 0;

  @override
  MaintenanceTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaintenanceTask(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MaintenanceTask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MaintenanceSessionAdapter extends TypeAdapter<MaintenanceSession> {
  @override
  final int typeId = 1;

  @override
  MaintenanceSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaintenanceSession(
      date: fields[0] as DateTime,
      odometer: fields[1] as int,
      tasks: (fields[2] as List).cast<MaintenanceTask>(),
    );
  }

  @override
  void write(BinaryWriter writer, MaintenanceSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.odometer)
      ..writeByte(2)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FuelEntryAdapter extends TypeAdapter<FuelEntry> {
  @override
  final int typeId = 2;

  @override
  FuelEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelEntry(
      date: fields[0] as DateTime,
      odometer: fields[1] as int,
      liters: fields[2] as double,
      pricePerLiter: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FuelEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.odometer)
      ..writeByte(2)
      ..write(obj.liters)
      ..writeByte(3)
      ..write(obj.pricePerLiter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
