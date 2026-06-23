import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../controllers/admin_controller.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final AdminController controller = AdminController.instance;

  @override
  void initState() {
    super.initState();
    controller.fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: GetBuilder<AdminController>(
        builder: (ctrl) {
          if (ctrl.isLoading && ctrl.students.isEmpty) {
            return const LoadingWidget(message: 'Loading students...');
          }
          return Obx(() {
            if (ctrl.students.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.people_outline,
                title: 'No students found',
                subtitle: 'Add your first student to get started',
              );
            }
            return RefreshIndicator(
              onRefresh: () => ctrl.fetchStudents(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.students.length,
                itemBuilder: (context, index) {
                  final student = ctrl.students[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          (student.name ?? '?')[0].toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        student.name ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          if (student.email != null)
                            Text(student.email!,
                                style:
                                    TextStyle(color: Colors.grey.shade600)),
                          if (student.course != null)
                            Text(student.course!,
                                style:
                                    TextStyle(color: Colors.grey.shade600)),
                          if (student.studentCode != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Code: ${student.studentCode}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_rounded,
                            color: Colors.red.shade400),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Student'),
                              content: Text(
                                  'Are you sure you want to delete ${student.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (student.id != null) {
                                      ctrl.deleteStudent(student.id!);
                                    }
                                    Navigator.pop(ctx);
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}
