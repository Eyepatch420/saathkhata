import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

// Email/password login is replaced by OTP. This screen redirects to phone entry.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouter.phoneEntry);
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
