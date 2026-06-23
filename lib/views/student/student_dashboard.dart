import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_dashboard/controllers/auth_controller.dart';
import 'package:student_dashboard/controllers/student_controller.dart';
import 'package:student_dashboard/routes/app_router.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = StudentController.instance;
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => AuthController.instance.logout(),
          ),
        ],
      ),
      body: Obx(() {
        final authUser = AuthController.instance.user.value;
        final student = controller.currentStudent.value ?? authUser;

        if (student == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          (student.name ?? '?')[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name ?? 'Unknown',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student.course ?? 'No course',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _DashboardCard(
                      icon: Icons.person_rounded,
                      title: 'Profile',
                      subtitle: 'View details',
                      color: Colors.blue,
                      onTap: () => AppRouter.navigatorKey.currentState
                          ?.pushNamed(AppRouter.profile),
                    ),
                    _DashboardCard(
                      icon: Icons.report_problem_rounded,
                      title: 'Task completed',
                      subtitle: 'Submit task',
                      color: Colors.orange,
                      onTap: () => AppRouter.navigatorKey.currentState
                          ?.pushNamed(AppRouter.reportProblem),
                    ),
                    _DashboardCard(
                      icon: Icons.history_rounded,
                      title: 'History',
                      subtitle: 'View tasks',
                      color: Colors.green,
                      onTap: () => AppRouter.navigatorKey.currentState
                          ?.pushNamed(AppRouter.complaintHistory),
                    ),
                    _DashboardCard(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out',
                      color: Colors.red,
                      onTap: () => AuthController.instance.logout(),
                    ),
                    _DashboardCard(
                      icon: Icons.assignment,
                      title: 'Tasks',
                      subtitle: 'View Assigned Tasks',
                      color: Colors.purple,
                      onTap: () => AppRouter.navigatorKey.currentState
                          ?.pushNamed(AppRouter.studentTasks),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
