// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:student_dashboard/controllers/student_controller.dart';
import 'package:student_dashboard/models/task_model.dart';
import 'package:student_dashboard/services/task_service.dart';

class StudentTasksScreen extends StatefulWidget {
  const StudentTasksScreen({super.key});

  @override
  State<StudentTasksScreen> createState() => _StudentTasksScreenState();
}

class _StudentTasksScreenState extends State<StudentTasksScreen> {
  final TaskService _taskService = TaskService();

  List<TaskModel> tasks = [];

  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();

  //   loadTasks();
  // }

  @override
  void initState() {
    super.initState();

    print("Student Tasks Screen Opened");

    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final student = StudentController.instance.currentStudent.value;

      print("Current Student: $student");
      print("Student ID: ${student?.studentId}");

      if (student == null || student.studentId == null) {
        print("Student not found");
        return;
      }

      final data = await _taskService.fetchTasks(student.studentId!);

      print("Fetched Tasks: $data");

      setState(() {
        tasks = data.map((e) => TaskModel.fromMap(e)).toList();
      });

      print("Task Count: ${tasks.length}");
    } catch (e) {
      print("TASK FETCH ERROR: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _formatDeadline(DateTime? deadline) {
    if (deadline == null) return 'No deadline';
    return '${deadline.day}/${deadline.month}/${deadline.year}  ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
  }

  bool _isOverdue(DateTime? deadline) {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tasks")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? const Center(child: Text("No tasks assigned"))
          : RefreshIndicator(
              onRefresh: loadTasks,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final overdue = _isOverdue(task.deadline);

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  task.status,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: task.status == 'Completed'
                                    ? Colors.green.shade100
                                    : overdue
                                    ? Colors.red.shade100
                                    : Colors.orange.shade100,
                              ),
                            ],
                          ),
                          if (task.description != null &&
                              task.description!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              task.description!,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: overdue ? Colors.red : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDeadline(task.deadline),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: overdue
                                      ? Colors.red
                                      : Colors.grey.shade600,
                                  fontWeight: overdue
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (overdue && task.status != 'Completed')
                                const SizedBox(width: 8),
                              if (overdue && task.status != 'Completed')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Overdue',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
