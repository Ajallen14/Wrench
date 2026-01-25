import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';
import '../providers/bike_provider.dart';

class MaintenanceTaskTile extends StatelessWidget {
  final MaintenanceSession session;
  final MaintenanceTask task;

  const MaintenanceTaskTile({
    super.key,
    required this.session,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: (task.isCompleted && task.completedDate != null)
          ? Text(
              "Completed: ${DateFormat('dd MMM hh:mm a').format(task.completedDate!)}",
              style: const TextStyle(fontSize: 12, color: Colors.green),
            )
          : null,
      
      value: task.isCompleted,
      activeColor: Colors.blueAccent,
      onChanged: (val) {
        Provider.of<BikeProvider>(context, listen: false).toggleTask(session, task);
      },
    );
  }
}