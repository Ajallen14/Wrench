import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';
import '../providers/bike_provider.dart';
import '../widgets/resizable_flip_card.dart';
import '../widgets/maintenance_task_tile.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    final allSessions = provider.sessions;

    // --- FILTER LOGIC ---
    // If search is empty, show everything.
    // If search has text, only show sessions where at least one task matches the text.
    final filteredSessions = _searchQuery.isEmpty
        ? allSessions
        : allSessions.where((session) {
            // Check if any task title contains the search query (case insensitive)
            return session.tasks.any((task) =>
                task.title.toLowerCase().contains(_searchQuery.toLowerCase()));
          }).toList();

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // 1. THE SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search service history...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = "";
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),

          // 2. THE LIST VIEW
          Expanded(
            child: filteredSessions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.history : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? "No Service History"
                              : "No results for \"$_searchQuery\"",
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSessions.length,
                    itemBuilder: (ctx, index) {
                      return _buildTimelineItem(
                        ctx,
                        filteredSessions[index],
                        index == filteredSessions.length - 1,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, MaintenanceSession session, bool isLast) {
    bool allDone = session.tasks.isNotEmpty && session.tasks.every((t) => t.isCompleted);

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
        child: GestureDetector(
          onLongPress: () => _showDeleteDialog(context, session),
          child: ResizableFlipCard(
            front: _buildCard(session, isFront: true),
            back: _buildCard(session, isFront: false, context: context),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(MaintenanceSession session, {required bool isFront, BuildContext? context}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isFront
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(session.date),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${session.odometer} km",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Highlight the search term if needed, but for now simple text
                  Text(
                    "${session.tasks.where((t) => t.isCompleted).length} / ${session.tasks.length} Tasks Done",
                    style: TextStyle(
                      color: (session.tasks.isNotEmpty && session.tasks.every((t) => t.isCompleted))
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text("Tap to view details • Long press to delete",
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Service Checklist", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  ...session.tasks.map((task) => MaintenanceTaskTile(
                        session: session,
                        task: task,
                      )),
                ],
              ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final kmController = TextEditingController();
    final taskController = TextEditingController();
    List<String> tempTasks = [];

    showDialog(
      context: context,
      builder: (ctx) {
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
                            decoration:
                                const InputDecoration(labelText: "Add Task (e.g. Oil Change)"),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: () {
                            if (taskController.text.isNotEmpty) {
                              setState(() {
                                tempTasks.add(taskController.text);
                                taskController.clear();
                              });
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (tempTasks.isEmpty)
                      const Text("No tasks added yet.", style: TextStyle(color: Colors.grey))
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
                              leading: const Icon(Icons.check_circle_outline, size: 20),
                              title: Text(tempTasks[i]),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 16, color: Colors.red),
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
                        tasks: tempTasks.map((t) => MaintenanceTask(title: t)).toList(),
                      );
                      Provider.of<BikeProvider>(context, listen: false).addSession(newSession);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, MaintenanceSession session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Session"),
        content: const Text("Are you sure you want to remove this maintenance record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BikeProvider>(context, listen: false).deleteSession(session);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}