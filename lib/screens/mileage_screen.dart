import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';
import '../providers/bike_provider.dart';
import '../widgets/mileage_graph_card.dart'; // Import your new widget

class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    final entries = provider.fuelEntries; 

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => _showAddFuelDialog(context),
          child: const Icon(Icons.local_gas_station, color: Colors.white),
        ),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("Add your first fuel refill!"))
          : ListView(
              children: [
                // 1. USE THE NEW WIDGET HERE
                if (entries.length > 1) 
                  MileageGraphCard(entries: entries),

                // 2. The List Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: const Text(
                    "History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                
                ListView.separated(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemBuilder: (ctx, index) {
                    final entry = entries[index];
                    return _buildFuelTile(context, entry);
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
    );
  }

  // Helper for the List Tile
  Widget _buildFuelTile(BuildContext context, FuelEntry entry) {
    return Dismissible(
      key: ValueKey(entry.key),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        Provider.of<BikeProvider>(context, listen: false).deleteFuelEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fuel entry deleted")),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.speed, color: Colors.green),
        ),
        title: Text(
          "${entry.tripDistance} km trip",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('dd MMM yyyy').format(entry.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${entry.mileage.toStringAsFixed(1)} km/L",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            Text(
              "${entry.liters} L",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFuelDialog(BuildContext context) {
    final tripController = TextEditingController();
    final literController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Fuel Log"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tripController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Trip Distance (km)",
                prefixIcon: Icon(Icons.add_road),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: literController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Liters Filled",
                prefixIcon: Icon(Icons.local_gas_station),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (tripController.text.isNotEmpty && literController.text.isNotEmpty) {
                final entry = FuelEntry(
                  date: DateTime.now(),
                  tripDistance: double.parse(tripController.text),
                  liters: double.parse(literController.text),
                );
                
                Provider.of<BikeProvider>(context, listen: false).addFuelEntry(entry);
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