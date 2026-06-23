import 'package:flutter/material.dart';
import '../routes/app_router.dart';

class SnackBarHelper {
  static void show(String message, {bool isError = false}) {
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade600 : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
