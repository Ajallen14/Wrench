import 'package:hive/hive.dart';

part 'bike_model.g.dart';

// --- Maintenance Models ---
@HiveType(typeId: 0)
class MaintenanceTask extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool isCompleted;
  MaintenanceTask({required this.title, this.isCompleted = false});
}

@HiveType(typeId: 1)
class MaintenanceSession extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  int odometer;
  @HiveField(2)
  List<MaintenanceTask> tasks;
  
  MaintenanceSession({required this.date, required this.odometer, required this.tasks});
}

// --- NEW: Fuel/Mileage Model ---
@HiveType(typeId: 2)
class FuelEntry extends HiveObject {
  @HiveField(0)
  DateTime date;
  
  @HiveField(1)
  int odometer; // Current reading
  
  @HiveField(2)
  double liters; // Fuel filled
  
  @HiveField(3)
  double pricePerLiter; // Optional, for cost tracking

  FuelEntry({
    required this.date, 
    required this.odometer, 
    required this.liters,
    this.pricePerLiter = 0.0,
  });
}