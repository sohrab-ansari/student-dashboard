import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../routes/app_router.dart';
import '../services/auth_service.dart';
import '../controllers/student_controller.dart';
import '../utils/snackbar_helper.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthService _authService = AuthService();

  final Rxn<UserModel> user = Rxn<UserModel>();

  final RxBool isLoading = false.obs;

  StreamSubscription<AuthState>? _subscription;

  bool _isLoadingUser = false;

  bool isRedirecting = false;

  bool get isLoggedIn => user.value != null;

  bool get isAdmin => user.value?.role == 'admin';

  @override
  void onInit() {
    super.onInit();

    _listenAuth();
  }

  void _listenAuth() {
    _subscription = _authService.authStateChanges.listen((state) async {
      if (state.event == AuthChangeEvent.tokenRefreshed) return;
      if (state.event == AuthChangeEvent.userUpdated) return;

      final session = state.session;

      if (session == null) {
        user.value = null;
        return;
      }

      await _loadUser(session.user);
    });
  }

  Future<bool> waitForSession(Duration timeout) async {
    if (isLoggedIn) return true;
    try {
      await _authService.authStateChanges
          .where((state) => state.session != null)
          .first
          .timeout(timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> checkSession() async {
    if (_isLoadingUser) return;
    if (isRedirecting) return;
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      await _loadUser(currentUser);
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;

      await _authService.signInWithGoogle();
    } catch (e) {
      print("GOOGLE LOGIN ERROR : $e");

      SnackBarHelper.show("Google login failed", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUser(User authUser) async {
    if (_isLoadingUser) return;

    _isLoadingUser = true;

    try {
      final email = authUser.email;

      if (email == null) return;

      final profile = await _authService.fetchProfile(email);

      if (profile == null) {
        SnackBarHelper.show("Admin profile not found", isError: true);

        await _authService.signOut();

        return;
      }

      final userModel = UserModel.fromMap(profile);

      if (userModel.role != "admin") {
        await _authService.signOut();

        user.value = null;

        SnackBarHelper.show("Only admin can login here", isError: true);

        return;
      }

      user.value = userModel;

      redirectToDashboard();
    } catch (e) {
      print("LOAD USER ERROR : $e");
    } finally {
      _isLoadingUser = false;
    }
  }

  void redirectToDashboard() {
    if (user.value == null) return;

    if (!isAdmin) return;

    AppRouter.navigatorKey.currentState?.pushReplacementNamed(
      AppRouter.adminDashboard,
    );
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authService.signOut();

      user.value = null;

      isRedirecting = false;

      if (Get.isRegistered<StudentController>()) {
        StudentController.instance.currentStudent.value = null;
      }

      AppRouter.navigatorKey.currentState?.pushReplacementNamed(
        AppRouter.roleSelection,
      );
    } catch (e) {
      print("LOGOUT ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();

    super.onClose();
  }
}
