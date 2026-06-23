import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskController extends GetxController {
  static TaskController get instance => Get.find();

  final TaskService _taskService = TaskService();

  final tasks = <TaskModel>[].obs;

  bool isLoading = false;

  Future<void> loadTasks(String studentId) async {
    try {
      isLoading = true;
      update();

      tasks.value =
          (await _taskService.fetchTasks(studentId)).cast<TaskModel>();
    } finally {
      isLoading = false;
      update();
    }
  }
}