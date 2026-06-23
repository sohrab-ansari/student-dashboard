import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../utils/constants.dart';

class AuthService {
  final SupabaseService _supabase = SupabaseService();

  SupabaseClient get _client => _supabase.client;

  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  bool get isLoggedIn => currentSession != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;



  Future<bool> signInWithGoogle() async {
  try {

    final result = await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback/',
    );

    print("GOOGLE LOGIN RESULT: $result");

    final user = _client.auth.currentUser;

    print("CURRENT USER: ${user?.email}");

    return result;

  } catch(e){

    print("GOOGLE ERROR: $e");

    return false;
  }
}

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<Map<String, dynamic>?> fetchProfile(String email) async {
    return await _client
        .from(AppConstants.profilesTable)
        .select()
        .eq('email', email)
        .maybeSingle();
  }

  Future<Map<String, dynamic>> createProfile({
    required String id,
    required String email,
    required String name,
    required String role,
  }) async {
    final response = await _client
        .from(AppConstants.profilesTable)
        .insert({'id': id, 'email': email, 'name': name, 'role': role})
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>?> loginWithCode(String code) async {
  final response = await _client
      .from('students')
      .select()
      .eq('student_code', code)
      .maybeSingle();

  return response;
}
}
