import 'dart:math';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/complaint_model.dart';
import '../services/user_service.dart';
import '../services/complaint_service.dart';
import '../utils/snackbar_helper.dart';
import '../routes/app_router.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  final UserService _userService = UserService();
  final ComplaintService _complaintService = ComplaintService();

  bool isLoading = false;
  final students = <UserModel>[].obs;
  final complaints = <ComplaintModel>[].obs;

  String generateSecurityCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> addStudent(String name, String email, String course) async {
    try {
      isLoading = true;
      update();
      final code = generateSecurityCode();
      final user = UserModel(
        name: name,
        email: email,
        course: course,
        studentCode: code,
      );
      await _userService.createStudent(user);
      await fetchStudents();
      final navigator = AppRouter.navigatorKey.currentState;
      navigator?.pop();
      SnackBarHelper.show('Student added successfully. Code: $code');
    } catch (e) {
      print("ADD STUDENT ERROR: $e");
      SnackBarHelper.show('Failed to add student', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchStudents() async {
    try {
      isLoading = true;
      update();
      final result = await _userService.fetchStudents();
      students.value = result;
    } catch (e) {
      print("FETCH STUDENTS ERROR: $e");
      SnackBarHelper.show('Failed to fetch students', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _userService.deleteStudent(id);
      students.removeWhere((s) => s.id == id);
      SnackBarHelper.show('Student deleted successfully');
    } catch (e) {
      SnackBarHelper.show('Failed to delete student', isError: true);
    }
  }

  Future<void> fetchComplaints() async {
    try {
      isLoading = true;
      update();
      final result = await _complaintService.fetchComplaints();
      complaints.value = result;
    } catch (e) {
      print("FETCH COMPLAINTS ERROR: $e");
      SnackBarHelper.show('Failed to fetch tasks', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateComplaintStatus(String id, String status) async {
    try {
      await _complaintService.updateComplaintStatus(id, status);
      await fetchComplaints();
      SnackBarHelper.show('Task status updated to $status');
    } catch (e) {
      SnackBarHelper.show('Failed to update task status', isError: true);
    }
  }
}
