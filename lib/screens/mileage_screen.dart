import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';
import '../providers/bike_provider.dart';

class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    final entries = provider.fuelEntries;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 90.0,
        ), 
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => _showAddFuelDialog(context),
          child: const Icon(Icons.local_gas_station, color: Colors.white),
        ),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("Add your first fuel refill!"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, index) {
                final entry = entries[index];
                final mileage = provider.calculateMileage(entry);

                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.speed, color: Colors.green),
                  ),
                  title: Text("${entry.odometer} km"),
                  subtitle: Text(DateFormat('dd MMM').format(entry.date)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$mileage km/L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${entry.liters} L",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showAddFuelDialog(BuildContext context) {
    final odoController = TextEditingController();
    final literController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Fuel"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: odoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Current Odometer"),
            ),
            TextField(
              controller: literController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Liters Filled"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (odoController.text.isNotEmpty &&
                  literController.text.isNotEmpty) {
                final entry = FuelEntry(
                  date: DateTime.now(),
                  odometer: int.parse(odoController.text),
                  liters: double.parse(literController.text),
                );
                Provider.of<BikeProvider>(
                  context,
                  listen: false,
                ).addFuelEntry(entry);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
