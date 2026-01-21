import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';
import '../providers/bike_provider.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    final sessions = provider.sessions;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: sessions.isEmpty
          ? const Center(
              child: Text(
                "No Service History",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (ctx, index) {
                // Pass 'true' if it is the last item to stop the timeline line
                return _buildTimelineItem(
                  ctx,
                  sessions[index],
                  index == sessions.length - 1,
                );
              },
            ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    MaintenanceSession session,
    bool isLast,
  ) {
    // Check if all tasks in this session are completed
    bool allDone =
        session.tasks.isNotEmpty && session.tasks.every((t) => t.isCompleted);

    return TimelineTile(
      isFirst: false,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: allDone ? Colors.green : Colors.orange,
        thickness: 3,
      ),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: allDone ? Colors.green : Colors.orange,
        iconStyle: IconStyle(
          iconData: allDone ? Icons.check : Icons.build,
          color: Colors.white,
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 12),
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          // Front side: Summary
          front: _buildCard(session, isFront: true),
          // Back side: Checklist
          back: _buildCard(session, isFront: false, context: context),
        ),
      ),
    );
  }

  Widget _buildCard(
    MaintenanceSession session, {
    required bool isFront,
    BuildContext? context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isFront
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(session.date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${session.odometer} km",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${session.tasks.where((t) => t.isCompleted).length} / ${session.tasks.length} Tasks Done",
                    style: TextStyle(
                      color: session.tasks.every((t) => t.isCompleted)
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Tap to view details",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Service Checklist",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...session.tasks.map(
                    (task) => CheckboxListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      value: task.isCompleted,
                      onChanged: (val) {
                        // Update Hive database via Provider
                        Provider.of<BikeProvider>(
                          context!,
                          listen: false,
                        ).toggleTask(session, task);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // --- Logic to Add a New Session ---
  void _showAddDialog(BuildContext context) {
    final kmController = TextEditingController();
    final taskController = TextEditingController();
    List<String> tempTasks = [];

    showDialog(
      context: context,
      builder: (ctx) {
        // add/remove tasks 
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("New Service Session"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: kmController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Odometer (km)",
                        prefixIcon: Icon(Icons.speed),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: const InputDecoration(
                              labelText: "Add Task (e.g. Oil Change)",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            if (taskController.text.isNotEmpty) {
                              setState(() {
                                tempTasks.add(taskController.text);
                                taskController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // List of added tasks in the dialog
                    if (tempTasks.isEmpty)
                      const Text(
                        "No tasks added yet.",
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      Container(
                        height: 150,
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: tempTasks.length,
                          itemBuilder: (ctx, i) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.check_circle_outline,
                                size: 20,
                              ),
                              title: Text(tempTasks[i]),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tempTasks.removeAt(i);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (kmController.text.isNotEmpty && tempTasks.isNotEmpty) {
                      final newSession = MaintenanceSession(
                        date: DateTime.now(),
                        odometer: int.parse(kmController.text),
                        tasks: tempTasks
                            .map((t) => MaintenanceTask(title: t))
                            .toList(),
                      );
                      // Save to Hive
                      Provider.of<BikeProvider>(
                        context,
                        listen: false,
                      ).addSession(newSession);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
