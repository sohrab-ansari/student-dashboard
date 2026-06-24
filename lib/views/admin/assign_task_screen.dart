// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../services/task_service.dart';
import '../../models/user_model.dart';
import '../../utils/snackbar_helper.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final TaskService _taskService = TaskService();

  UserModel? selectedStudent;
  bool isLoading = false;
  DateTime? _deadline;

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );
    if (time == null) return;

    setState(() {
      _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    AdminController.instance.fetchStudents();
  }

  Future<void> assignTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedStudent == null) {
      SnackBarHelper.show("Please select a student", isError: true);
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await _taskService.assignTask(
        studentId: selectedStudent!.studentId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _deadline,
      );

      SnackBarHelper.show("Task assigned successfully");

      _titleController.clear();
      _descriptionController.clear();

      setState(() {
        selectedStudent = null;
        _deadline = null;
      });
    } catch (e) {
      print("ASSIGN TASK ERROR: $e");

      SnackBarHelper.show("Failed to assign task", isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Assign Task")),
      body: GetX<AdminController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<UserModel>(
                    value: selectedStudent,
                    decoration: const InputDecoration(
                      labelText: "Select Student",
                      border: OutlineInputBorder(),
                    ),
                    items: controller.students.map((student) {
                      return DropdownMenuItem(
                        value: student,
                        child: Text("${student.name} (${student.studentCode})"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudent = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Task Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter task title";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: _pickDeadline,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Deadline",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      child: Text(
                        _deadline != null
                            ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}  ${_deadline!.hour.toString().padLeft(2, '0')}:${_deadline!.minute.toString().padLeft(2, '0')}'
                            : 'Select deadline',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : assignTask,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Assign Task"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
