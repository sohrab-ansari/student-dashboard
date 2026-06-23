import 'supabase_service.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

class UserService {
  final SupabaseService _supabase = SupabaseService();

  Future<UserModel> createStudent(UserModel user) async {
    final response = await _supabase.client
        .from(AppConstants.studentsTable)
        .insert(user.toMap())
        .select()
        .single();
    return UserModel.fromMap(response);
  }

  Future<List<UserModel>> fetchStudents() async {
    final response = await _supabase.client
        .from(AppConstants.studentsTable)
        .select()
        .order('id');
    return (response as List)
        .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteStudent(String id) async {
    await _supabase.client
        .from(AppConstants.studentsTable)
        .delete()
        .eq('id', id);
  }

  // Future<UserModel?> fetchStudentByCode(String code) async {
  //   final response = await _supabase.client
  //       .from(AppConstants.studentsTable)
  //       .select()
  //       .eq('student_code', code)
  //       .maybeSingle();
  //   if (response != null) {
  //     return UserModel.fromMap(response);
  //   }
  //   return null;
  // }

  Future<UserModel?> fetchStudentByCode(String code) async {
    try {
      print("SEARCHING CODE: [$code]");

      final response = await _supabase.client
          .from(AppConstants.studentsTable)
          .select()
          .eq('student_code', code.trim())
          .maybeSingle();

      print("STUDENT RESPONSE: $response");

      if (response != null) {
        return UserModel.fromMap(response);
      }

      return null;
    } catch (e) {
      print("STUDENT LOGIN ERROR: $e");
      return null;
    }
  }

  Future<UserModel?> fetchStudentById(String id) async {
    final response = await _supabase.client
        .from(AppConstants.studentsTable)
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response != null) {
      return UserModel.fromMap(response);
    }
    return null;
  }
}
