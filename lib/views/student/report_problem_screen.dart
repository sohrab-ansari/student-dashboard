import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validators.dart';
import '../../controllers/complaint_controller.dart';

class ReportProblemScreen extends StatelessWidget {
  ReportProblemScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task completed'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submit a Task',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Describe your task details',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Task Details',
                  hintText: 'Describe the problem you are facing...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => Validators.required(v, 'Task'),
                maxLines: 6,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 32),
              GetBuilder<ComplaintController>(
                builder: (ctrl) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              ctrl.submitComplaint(
                                  _messageController.text.trim());
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: ctrl.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit Task'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
