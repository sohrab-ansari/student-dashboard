// import 'supabase_service.dart';

// class TaskService {
//   final SupabaseService _supabase = SupabaseService();

//   Future<void> assignTask({
//     required String studentId,
//     required String title,
//     required String description,
//   }) async {
//     final user = _supabase.client.auth.currentUser;

//     print("ADMIN AUTH ID: ${user?.id}");

//     final profile = await _supabase.client
//         .from('profiles')
//         .select()
//         .eq('id', user!.id)
//         .single();

//     print("ADMIN PROFILE: $profile");

//     await _supabase.client.from('tasks').insert({
//       'student_id': studentId,

//       'title': title,

//       'description': description,

//       'status': 'Pending',
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchTasks(String studentId) async {
//     final response = await _supabase.client
//         .from('tasks')
//         .select()
//         .eq('student_id', studentId)
//         .order('id');

//     return List<Map<String, dynamic>>.from(response);
//   }
// }



import 'supabase_service.dart';

class TaskService {

  final SupabaseService _supabase = SupabaseService();


  Future<void> assignTask({
    required String studentId,
    required String title,
    required String description,
    DateTime? deadline,
  }) async {
    final data = {
      'student_id': studentId,
      'title': title,
      'description': description,
      'status': 'Pending',
    };

    try {
      if (deadline != null) {
        data['deadline'] = deadline.toIso8601String();
      }
      await _supabase.client.from('tasks').insert(data);
    } catch (e) {
      if (deadline != null && e.toString().contains('deadline')) {
        data.remove('deadline');
        await _supabase.client.from('tasks').insert(data);
      } else {
        rethrow;
      }
    }
  }


  Future<List<Map<String,dynamic>>> fetchTasks(
      String studentId) async {

    final response = await _supabase.client
        .from('tasks')
        .select()
        .eq('student_id', studentId)
        .order('id');


    return List<Map<String,dynamic>>.from(response);

  }

}