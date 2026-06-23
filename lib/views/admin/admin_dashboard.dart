import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => AuthController.instance.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage students and complaints',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: Icons.person_add_rounded,
                    title: 'Add Student',
                    subtitle: 'Register new students',
                    color: Colors.blue,
                    onTap: () => AppRouter.navigatorKey.currentState?.pushNamed(
                      AppRouter.addStudent,
                    ),
                  ),
                  _DashboardCard(
                    icon: Icons.people_rounded,
                    title: 'Students',
                    subtitle: 'View all students',
                    color: Colors.green,
                    onTap: () => AppRouter.navigatorKey.currentState?.pushNamed(
                      AppRouter.studentList,
                    ),
                  ),
                  _DashboardCard(
                    icon: Icons.report_problem_rounded,
                    title: 'Task completed',
                    subtitle: 'Manage completed tasks',
                    color: Colors.orange,
                    onTap: () => AppRouter.navigatorKey.currentState?.pushNamed(
                      AppRouter.complaintManagement,
                    ),
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
                    title: 'Assign Task',
                    subtitle: 'Assign tasks to students',
                    color: Colors.purple,
                    onTap: () => AppRouter.navigatorKey.currentState?.pushNamed(
                      AppRouter.assignTask,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
