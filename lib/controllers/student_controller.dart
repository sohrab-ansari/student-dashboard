import 'package:get/get.dart';
import '../utils/snackbar_helper.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../routes/app_router.dart';
import 'auth_controller.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  final UserService _userService = UserService();

  bool isLoading = false;
  final currentStudent = Rxn<UserModel>();

  Future<void> loginWithCode(String code) async {
    try {
      isLoading = true;
      update();

      final student = await _userService.fetchStudentByCode(code);

      if (student == null) {
        SnackBarHelper.show("Invalid student code", isError: true);
        return;
      }

      // currentStudent.value = student;

      // AppRouter.navigatorKey.currentState?.pushReplacementNamed(
      //   AppRouter.studentDashboard,
      // );
      currentStudent.value = student;

      print("LOGIN SUCCESS STUDENT: ${currentStudent.value?.name}");
      print("GOING TO DASHBOARD");

      // AppRouter.navigatorKey.currentState?.pushReplacementNamed(
      //   AppRouter.studentDashboard,
      // );
      AppRouter.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.studentDashboard,
        (route) => false,
      );
    } catch (e) {
      print("STUDENT LOGIN ERROR : $e");
      SnackBarHelper.show("Student login failed", isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      update();
      if (currentStudent.value?.id != null) {
        final profile = await _userService.fetchStudentById(
          currentStudent.value!.id!,
        );
        if (profile != null) {
          currentStudent.value = profile;
        }
      }
    } catch (e) {
      SnackBarHelper.show('Failed to fetch student profile', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  void logout() {
    AuthController.instance.logout();
  }
}
