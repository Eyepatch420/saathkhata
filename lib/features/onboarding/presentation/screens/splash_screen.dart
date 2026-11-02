import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Minimum branding delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final storage = getIt<StorageService>();
    final hasSeenOnboarding = await storage.hasSeenOnboarding();

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      // First launch: show language selection → onboarding → role selection
      context.go(AppRouter.languageSelection);
      return;
    }

    // If the user is already authenticated, the router redirect (driven by
    // AuthBloc) will navigate them to the correct home screen automatically.
    // We only need to handle the unauthenticated case here.
    final accessToken = await storage.getAccessToken();

    if (!mounted) return;

    if (accessToken == null) {
      context.go(AppRouter.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: AppTypography.h1.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tagline,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
