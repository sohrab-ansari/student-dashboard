import 'package:get/get.dart';
import '../models/complaint_model.dart';
import '../services/complaint_service.dart';
import '../utils/snackbar_helper.dart';
import '../routes/app_router.dart';
import 'student_controller.dart';

class ComplaintController extends GetxController {
  static ComplaintController get instance => Get.find();

  final ComplaintService _complaintService = ComplaintService();
  final StudentController _studentController = StudentController.instance;

  bool isLoading = false;
  final complaints = <ComplaintModel>[].obs;

  Future<void> submitComplaint(String message) async {
    try {
      isLoading = true;
      update();
      if (_studentController.currentStudent.value?.id == null) {
        SnackBarHelper.show('User not found', isError: true);
        return;
      }
      final complaint = ComplaintModel(
        userId: _studentController.currentStudent.value!.id,
        message: message,
        status: 'Pending',
      );
      await _complaintService.addComplaint(complaint);
      await fetchComplaintHistory();
      final navigator = AppRouter.navigatorKey.currentState;
      navigator?.pop();
      SnackBarHelper.show('Task submitted successfully');
    } catch (e) {
      print("SUBMIT COMPLAINT ERROR: $e");
      SnackBarHelper.show('Failed to submit task', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchComplaintHistory() async {
    try {
      isLoading = true;
      update();
      if (_studentController.currentStudent.value?.id == null) return;
      final result = await _complaintService.fetchUserComplaints(
        _studentController.currentStudent.value!.id!,
      );
      complaints.value = result;
    } catch (e) {
      SnackBarHelper.show('Failed to fetch task history', isError: true);
    } finally {
      isLoading = false;
      update();
    }
  }
}
