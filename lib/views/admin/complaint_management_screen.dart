import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../controllers/admin_controller.dart';

class ComplaintManagementScreen extends StatefulWidget {
  const ComplaintManagementScreen({super.key});

  @override
  State<ComplaintManagementScreen> createState() =>
      _ComplaintManagementScreenState();
}

class _ComplaintManagementScreenState
    extends State<ComplaintManagementScreen> {
  final AdminController controller = AdminController.instance;

  @override
  void initState() {
    super.initState();
    controller.fetchComplaints();
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task completed'),
      ),
      body: GetBuilder<AdminController>(
        builder: (ctrl) {
          if (ctrl.isLoading && ctrl.complaints.isEmpty) {
            return const LoadingWidget(message: 'Loading tasks...');
          }
          return Obx(() {
            if (ctrl.complaints.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.report_problem_outlined,
                title: 'No tasks',
                subtitle: 'No tasks have been submitted yet',
              );
            }
            return RefreshIndicator(
              onRefresh: () => ctrl.fetchComplaints(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.complaints.length,
                itemBuilder: (context, index) {
                  final complaint = ctrl.complaints[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (complaint.userName != null)
                                Text(
                                  complaint.userName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(complaint.status)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  complaint.status ?? 'Pending',
                                  style: TextStyle(
                                    color: _statusColor(complaint.status),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(complaint.message ?? ''),
                          if (complaint.createdAt != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              complaint.createdAt!
                                  .toString()
                                  .substring(0, 19)
                                  .replaceAll('T', ' '),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          if (complaint.status?.toLowerCase() == 'pending')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (complaint.id != null) {
                                      ctrl.updateComplaintStatus(
                                          complaint.id!, 'Resolved');
                                    }
                                  },
                                  child: const Text('Resolve'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    if (complaint.id != null) {
                                      ctrl.updateComplaintStatus(
                                          complaint.id!, 'Rejected');
                                    }
                                  },
                                  child: Text(
                                    'Reject',
                                    style:
                                        TextStyle(color: Colors.red.shade400),
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
            );
          });
        },
      ),
    );
  }
}
