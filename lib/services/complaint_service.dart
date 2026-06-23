import 'supabase_service.dart';
import '../utils/constants.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final SupabaseService _supabase = SupabaseService();

  Future<ComplaintModel> addComplaint(ComplaintModel complaint) async {
    final response = await _supabase.client
        .from(AppConstants.complaintsTable)
        .insert(complaint.toMap())
        .select()
        .single();
    return ComplaintModel.fromMap(response);
  }

  Future<List<ComplaintModel>> fetchComplaints() async {
    final response = await _supabase.client
        .from(AppConstants.complaintsTable)
        .select('*, students(name)')
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => ComplaintModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ComplaintModel>> fetchUserComplaints(String userId) async {
    final response = await _supabase.client
        .from(AppConstants.complaintsTable)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => ComplaintModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateComplaintStatus(String id, String status) async {
    await _supabase.client
        .from(AppConstants.complaintsTable)
        .update({'status': status})
        .eq('id', id);
  }
}
