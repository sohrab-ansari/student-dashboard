// import 'package:flutter/material.dart';
// import '../controllers/auth_controller.dart';
// import '../utils/snackbar_helper.dart';
// import '../views/auth/splash_screen.dart';
// import '../views/auth/role_selection_screen.dart';
// import '../views/auth/admin_login_screen.dart';
// import '../views/auth/student_login_screen.dart';
// import '../views/admin/admin_dashboard.dart';
// import '../views/admin/add_student_screen.dart';
// import '../views/admin/student_list_screen.dart';
// import '../views/admin/complaint_management_screen.dart';
// import '../views/student/student_dashboard.dart';
// import '../views/student/profile_screen.dart';
// import '../views/student/report_problem_screen.dart';
// import '../views/student/complaint_history_screen.dart';
// import '../controllers/student_controller.dart';

// class AppRouter {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static const String splash = '/';
//   static const String roleSelection = '/role-selection';
//   static const String adminLogin = '/admin-login';
//   static const String studentLogin = '/student-login';
//   static const String adminDashboard = '/admin-dashboard';
//   static const String addStudent = '/add-student';
//   static const String studentList = '/student-list';
//   static const String complaintManagement = '/complaint-management';
//   static const String studentDashboard = '/student-dashboard';
//   static const String profile = '/profile';
//   static const String reportProblem = '/report-problem';
//   static const String complaintHistory = '/complaint-history';
//   static const studentTasks = '/student-tasks';
//   static const assignTask = '/assign-task';

//   // static final List<String> _adminRoutes = [
//   //   adminDashboard,
//   //   addStudent,
//   //   studentList,
//   //   complaintManagement,
//   // ];

//   static final List<String> _adminRoutes = [
//   adminDashboard,
//   addStudent,
//   studentList,
//   complaintManagement,
//   assignTask,
// ];

//   // static final List<String> _studentRoutes = [
//   //   studentDashboard,
//   //   profile,
//   //   reportProblem,
//   //   complaintHistory,
//   // ];

//   static final List<String> _studentRoutes = [
//   studentDashboard,
//   profile,
//   reportProblem,
//   complaintHistory,
//   studentTasks,
// ];

//   static final List<String> _protectedRoutes = [
//     ..._adminRoutes,
//     ..._studentRoutes,
//   ];

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final auth = AuthController.instance;

//     // if (_protectedRoutes.contains(settings.name)) {
//     //   if (!auth.isLoggedIn) {
//     //     return MaterialPageRoute(
//     //       builder: (_) => const RoleSelectionScreen(),
//     //       settings: const RouteSettings(name: roleSelection),
//     //     );
//     //   }
//     //   if (_adminRoutes.contains(settings.name) && !auth.isAdmin) {
//     //     SnackBarHelper.show('Access denied. Admin only.', isError: true);
//     //     return MaterialPageRoute(
//     //       builder: (_) => const RoleSelectionScreen(),
//     //       settings: const RouteSettings(name: roleSelection),
//     //     );
//     //   }
//     //   if (_studentRoutes.contains(settings.name) && auth.isAdmin) {
//     //     SnackBarHelper.show('Access denied. Student only.', isError: true);
//     //     return MaterialPageRoute(
//     //       builder: (_) => const RoleSelectionScreen(),
//     //       settings: const RouteSettings(name: roleSelection),
//     //     );
//     //   }
//     // }

//     if (_protectedRoutes.contains(settings.name)) {

//   // Student page protection
//   if (_studentRoutes.contains(settings.name)) {

//     final student =
//         StudentController.instance.currentStudent.value;

//     if (student == null) {
//       return MaterialPageRoute(
//         builder: (_) => const RoleSelectionScreen(),
//         settings: const RouteSettings(
//           name: roleSelection,
//         ),
//       );
//     }
//   }

//   // Admin page protection
//   if (_adminRoutes.contains(settings.name)) {

//     if (!auth.isLoggedIn) {
//       return MaterialPageRoute(
//         builder: (_) => const RoleSelectionScreen(),
//         settings: const RouteSettings(
//           name: roleSelection,
//         ),
//       );
//     }

//     if (!auth.isAdmin) {
//       SnackBarHelper.show(
//         'Admin only access',
//         isError: true,
//       );

//       return MaterialPageRoute(
//         builder: (_) => const RoleSelectionScreen(),
//         settings: const RouteSettings(
//           name: roleSelection,
//         ),
//       );
//     }
//   }
// }

//     WidgetBuilder builder;
//     switch (settings.name) {
//       case splash:
//         builder = (_) => const SplashScreen();
//       case roleSelection:
//         builder = (_) => const RoleSelectionScreen();
//       case adminLogin:
//         builder = (_) => const AdminLoginScreen();
//       case studentLogin:
//         builder = (_) => StudentLoginScreen();
//       case adminDashboard:
//         builder = (_) => const AdminDashboard();
//       case addStudent:
//         builder = (_) => AddStudentScreen();
//       case studentList:
//         builder = (_) => const StudentListScreen();
//       case complaintManagement:
//         builder = (_) => const ComplaintManagementScreen();
//       case studentDashboard:
//         builder = (_) => const StudentDashboard();
//       case profile:
//         builder = (_) => const ProfileScreen();
//       case reportProblem:
//         builder = (_) => ReportProblemScreen();
//       case complaintHistory:
//         builder = (_) => const ComplaintHistoryScreen();
//       default:
//         builder = (_) => const SplashScreen();

//     }

//     return MaterialPageRoute(builder: builder, settings: settings);
//   }
// }

import 'package:flutter/material.dart';
import 'package:student_dashboard/views/student/student_task_screen.dart';

import '../controllers/auth_controller.dart';
import '../controllers/student_controller.dart';
import '../utils/snackbar_helper.dart';

// Auth Screens
import '../views/auth/splash_screen.dart';
import '../views/auth/role_selection_screen.dart';
import '../views/auth/admin_login_screen.dart';
import '../views/auth/student_login_screen.dart';

// Admin Screens
import '../views/admin/admin_dashboard.dart';
import '../views/admin/add_student_screen.dart';
import '../views/admin/student_list_screen.dart';
import '../views/admin/complaint_management_screen.dart';
import '../views/admin/assign_task_screen.dart';

// Student Screens
import '../views/student/student_dashboard.dart';
import '../views/student/profile_screen.dart';
import '../views/student/report_problem_screen.dart';
import '../views/student/complaint_history_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Routes
  static const String splash = '/';

  static const String roleSelection = '/role-selection';

  static const String adminLogin = '/admin-login';

  static const String studentLogin = '/student-login';

  // Admin
  static const String adminDashboard = '/admin-dashboard';
  static const String addStudent = '/add-student';
  static const String studentList = '/student-list';
  static const String complaintManagement = '/complaint-management';
  static const String assignTask = '/assign-task';

  // Student
  static const String studentDashboard = '/student-dashboard';

  static const String profile = '/profile';

  static const String reportProblem = '/report-problem';

  static const String complaintHistory = '/complaint-history';

  static const String studentTasks = '/student-tasks';

  static const List<String> adminRoutes = [
    adminDashboard,
    addStudent,
    studentList,
    complaintManagement,
    assignTask,
  ];

  static const List<String> studentRoutes = [
    studentDashboard,
    profile,
    reportProblem,
    complaintHistory,
    studentTasks,
  ];

  static const List<String> protectedRoutes = [
    ...adminRoutes,
    ...studentRoutes,
  ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final auth = AuthController.instance;

    // Route Protection
    // if (protectedRoutes.contains(settings.name)) {
    //   // Admin protection
    //   if (adminRoutes.contains(settings.name)) {
    //     if (!auth.isLoggedIn || !auth.isAdmin) {
    //       Future.microtask(() {
    //         SnackBarHelper.show("Admin access required", isError: true);
    //       });

    //       return _route(const RoleSelectionScreen(), roleSelection);
    //     }
    //   }

    //   // Student protection
    //   if (studentRoutes.contains(settings.name)) {
    //     final student = StudentController.instance.currentStudent.value;

    //     if (!auth.isLoggedIn || student == null) {
    //       Future.microtask(() {
    //         SnackBarHelper.show("Student login required", isError: true);
    //       });

    //       return _route(const RoleSelectionScreen(), roleSelection);
    //     }
    //   }
    // }

    // Student protection
    if (studentRoutes.contains(settings.name)) {
      final student = StudentController.instance.currentStudent.value;
      if (!auth.isLoggedIn && student == null) {
        Future.microtask(() {
          SnackBarHelper.show("Student login required", isError: true);
        });

        return _route(const RoleSelectionScreen(), roleSelection);
      }
    }

    switch (settings.name) {
      case splash:
        return _route(const SplashScreen(), splash);

      case roleSelection:
        return _route(const RoleSelectionScreen(), roleSelection);

      case adminLogin:
        return _route(const AdminLoginScreen(), adminLogin);

      case studentLogin:
        return _route(StudentLoginScreen(), studentLogin);

      // ADMIN

      case adminDashboard:
        return _route(const AdminDashboard(), adminDashboard);

      case addStudent:
        return _route(AddStudentScreen(), addStudent);

      case studentList:
        return _route(const StudentListScreen(), studentList);

      case complaintManagement:
        return _route(const ComplaintManagementScreen(), complaintManagement);

      case assignTask:
        return _route(const AssignTaskScreen(), assignTask);

      // STUDENT

      case studentDashboard:
        return _route(const StudentDashboard(), studentDashboard);

      case profile:
        return _route(const ProfileScreen(), profile);

      case reportProblem:
        return _route(ReportProblemScreen(), reportProblem);

      case complaintHistory:
        return _route(const ComplaintHistoryScreen(), complaintHistory);

      case studentTasks:
        return _route(const StudentTasksScreen(), studentTasks);

      default:
        return _route(const SplashScreen(), splash);
    }
  }

  static MaterialPageRoute _route(Widget page, String name) {
    return MaterialPageRoute(
      builder: (_) => page,

      settings: RouteSettings(name: name),
    );
  }
}
