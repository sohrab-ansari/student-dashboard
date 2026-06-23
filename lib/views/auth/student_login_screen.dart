import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validators.dart';
import '../../controllers/student_controller.dart';
import '../../routes/app_router.dart';

class StudentLoginScreen extends StatelessWidget {
  StudentLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.person_rounded,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Student Login',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your security code to login',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Security Code',
                    prefixIcon: Icon(Icons.vpn_key_rounded),
                  ),
                  validator: Validators.securityCode,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),
                GetBuilder<StudentController>(
                  builder: (ctrl) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ctrl.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                ctrl.loginWithCode(
                                    _codeController.text.trim().toUpperCase());
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
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
                          : const Text('Login with Code'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      AppRouter.navigatorKey.currentState?.pop(),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
