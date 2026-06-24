import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class TaskService {
  final SupabaseService _supabase = SupabaseService();

  Future<void> assignTask({
    required int studentId,
    required String title,
    required String description,
    DateTime? dueDate,
  }) async {
    final data = {
      'student_id': studentId,
      'title': title.trim(),
      'description': description.trim(),
      'status': 'Pending',
      'due_date': dueDate?.toIso8601String(),
    };

    try {
      await _supabase.client.from('tasks').insert(data);
    } on PostgrestException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasks(int studentId) async {
    try {
      print("LOGIN STUDENT ID => $studentId");

      final response = await _supabase.client
          .from('tasks')
          .select()
          .eq('student_id', studentId)
          .order('id', ascending: false);

      print("ONLY STUDENT TASKS => $response");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("TASK FETCH ERROR => $e");

      rethrow;
    }
  }

  Future<void> updateTaskStatus({
    required int taskId,
    required String status,
  }) async {
    await _supabase.client
        .from('tasks')
        .update({'status': status})
        .eq('id', taskId);
  }

  Future<void> deleteTask(int taskId) async {
    await _supabase.client.from('tasks').delete().eq('id', taskId);
  }
}
