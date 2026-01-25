import 'package:hive/hive.dart';

part 'bike_model.g.dart';

@HiveType(typeId: 1)
class MaintenanceSession extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int odometer;

  @HiveField(2)
  List<MaintenanceTask> tasks;

  MaintenanceSession({
    required this.date,
    required this.odometer,
    required this.tasks,
  });
}

@HiveType(typeId: 2)
class MaintenanceTask extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  DateTime? completedDate;

  MaintenanceTask({
    required this.title, 
    this.isCompleted = false,
    this.completedDate,
  });
}

// --- FUEL ENTRY MODEL ---
@HiveType(typeId: 3)
@HiveType(typeId: 3)
class FuelEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double liters;

  @HiveField(3)
  double tripDistance;

  FuelEntry({
    required this.date, 
    required this.liters, 
    required this.tripDistance
  });

  double get mileage => tripDistance / liters;
}