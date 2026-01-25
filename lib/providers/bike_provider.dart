import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bike_model.dart';

class BikeProvider with ChangeNotifier {
  Box<MaintenanceSession>? _serviceBox;
  Box<FuelEntry>? _fuelBox;

  // 1. Add a flag to track if we are ready
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Dark Mode Logic
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- SAFE INITIALIZATION ---
  Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(1))
        Hive.registerAdapter(MaintenanceSessionAdapter());
      if (!Hive.isAdapterRegistered(2))
        Hive.registerAdapter(MaintenanceTaskAdapter());
      if (!Hive.isAdapterRegistered(3))
        Hive.registerAdapter(FuelEntryAdapter());

      // FORCE NEW DATABASE VERSION (v7)
      _serviceBox = await Hive.openBox<MaintenanceSession>(
        'maintenance_box_v7',
      );
      _fuelBox = await Hive.openBox<FuelEntry>('fuel_box_v7');

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print("DB Error: $e");
      _isInitialized = true;
      notifyListeners();
    }
  }

  // --- DATA ACCESS ---
  List<MaintenanceSession> get sessions {
    if (_serviceBox == null) return [];
    var list = _serviceBox!.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<FuelEntry> get fuelEntries {
    if (_fuelBox == null) return [];
    var list = _fuelBox!.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> addSession(MaintenanceSession session) async {
    await _serviceBox?.add(session);
    notifyListeners();
  }

  Future<void> deleteSession(MaintenanceSession session) async {
    await session.delete();
    notifyListeners();
  }

  void toggleTask(MaintenanceSession session, MaintenanceTask task) {
    task.isCompleted = !task.isCompleted;

    // IF Checked -> Save Today's Date
    // IF Unchecked -> Remove the Date
    if (task.isCompleted) {
      task.completedDate = DateTime.now();
    } else {
      task.completedDate = null;
    }

    session.save();
    notifyListeners();
  }

  Future<void> addFuelEntry(FuelEntry entry) async {
    await _fuelBox?.add(entry);
    notifyListeners();
  }

  Future<void> deleteFuelEntry(FuelEntry entry) async {
    await entry.delete();
    notifyListeners();
  }
}
