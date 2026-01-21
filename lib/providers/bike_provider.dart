import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bike_model.dart';

class BikeProvider with ChangeNotifier {
  late Box<MaintenanceSession> _serviceBox;
  late Box<FuelEntry> _fuelBox;
  
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  // Getters
  List<MaintenanceSession> get sessions {
    var list = _serviceBox.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    return list;
  }

  List<FuelEntry> get fuelEntries {
    var list = _fuelBox.values.toList();
    list.sort((a, b) => b.odometer.compareTo(a.odometer)); // Highest km first
    return list;
  }

  // --- Initialization ---
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(MaintenanceSessionAdapter());
    Hive.registerAdapter(MaintenanceTaskAdapter());
    Hive.registerAdapter(FuelEntryAdapter()); // New

    // Open Boxes
    _serviceBox = await Hive.openBox<MaintenanceSession>('maintenance_box');
    _fuelBox = await Hive.openBox<FuelEntry>('fuel_box');
    
    notifyListeners();
  }

  // --- Theme Logic ---
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- Maintenance Logic ---
  Future<void> addSession(MaintenanceSession session) async {
    await _serviceBox.add(session);
    notifyListeners();
  }

  void toggleTask(MaintenanceSession session, MaintenanceTask task) {
    task.isCompleted = !task.isCompleted;
    session.save();
    notifyListeners();
  }

  // --- Mileage Logic ---
  Future<void> addFuelEntry(FuelEntry entry) async {
    await _fuelBox.add(entry);
    notifyListeners();
  }

  // Calculate Mileage for a specific entry
  String calculateMileage(FuelEntry currentEntry) {
    // 1. Get all entries sorted by odometer (ascending for calculation)
    var allEntries = _fuelBox.values.toList();
    allEntries.sort((a, b) => a.odometer.compareTo(b.odometer));

    // 2. Find index of current entry
    int index = allEntries.indexOf(currentEntry);

    // 3. If it's the first entry ever, we can't calc mileage
    if (index == 0) return "-";

    // 4. Get previous entry
    FuelEntry previousEntry = allEntries[index - 1];

    // 5. Formula: (Dist / Fuel)
    int distance = currentEntry.odometer - previousEntry.odometer;
    double mileage = distance / currentEntry.liters;

    return mileage.toStringAsFixed(1); 
  }
}