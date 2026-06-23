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
    if (title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    if (description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }

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
      debugPrint('Assign Task Error: ${e.message}');
      rethrow;
    }
  }

  // Future<List<Map<String, dynamic>>> fetchTasks(int studentId) async {
  //   try {
  //     final response = await _supabase.client
  //         .from('tasks')
  //         .select()
  //         .eq('student_id', studentId)
  //         .order('id', ascending: true);

  //     return List<Map<String, dynamic>>.from(response);
  //   } on PostgrestException catch (e) {
  //     debugPrint('Fetch Tasks Error: ${e.message}');
  //     rethrow;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> fetchTasks(int studentId) async {
  //   final response = await _supabase.client
  //       .from('tasks')
  //       .select()
  //       .eq('student_id', studentId)
  //       .order('id', ascending: true);

  //   return List<Map<String, dynamic>>.from(response);
  // }

  // Future<List<Map<String, dynamic>>> fetchTasks(int studentId) async {
  //   final response = await _supabase.client
  //       .from('tasks')
  //       .select()
  //       .eq('student_id', studentId)
  //       .order('id', ascending: true);

  //   print("TASK DATA: $response");

  //   return List<Map<String, dynamic>>.from(response);
  // }

  Future<List<Map<String, dynamic>>> fetchTasks(int studentId) async {
    try {
      print("FETCHING TASKS FOR: $studentId");

      final response = await _supabase.client.from('tasks').select('*');

      print("RAW TASK RESPONSE: $response");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("FETCH ERROR: $e");
      rethrow;
    }
  }

  Future<void> updateTaskStatus({
    required int taskId,
    required String status,
  }) async {
    try {
      await _supabase.client
          .from('tasks')
          .update({'status': status})
          .eq('id', taskId);
    } on PostgrestException catch (e) {
      debugPrint('Update Task Error: ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _supabase.client.from('tasks').delete().eq('id', taskId);
    } on PostgrestException catch (e) {
      debugPrint('Delete Task Error: ${e.message}');
      rethrow;
    }
  }
}
