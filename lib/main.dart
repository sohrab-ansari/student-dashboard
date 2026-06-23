import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_dashboard/controllers/task_controller.dart';
import 'services/supabase_service.dart';
import 'utils/app_theme.dart';
import 'routes/app_router.dart';
import 'controllers/auth_controller.dart';
import 'controllers/student_controller.dart';
import 'controllers/admin_controller.dart';
import 'controllers/complaint_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService().initialize();

  Get.put(AuthController());
  Get.put(StudentController());
  Get.put(AdminController());
  Get.put(ComplaintController());
  Get.put(TaskController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
