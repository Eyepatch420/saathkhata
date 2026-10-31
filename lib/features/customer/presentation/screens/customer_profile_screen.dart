import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (_, current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.profile)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(context).viewPadding.bottom + 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAvatarSection(context, user),
                  const SizedBox(height: 32),
                  _SectionHeader(label: l10n.accountSettings),
                  const SizedBox(height: 8),
                  _ProfileItem(
                    icon: Icons.person_outline_rounded,
                    title: l10n.editProfile,
                    onTap: user != null
                        ? () => context.push(AppRouter.editProfile, extra: user)
                        : null,
                  ),
                  _ProfileItem(
                    icon: Icons.lock_outline_rounded,
                    title: l10n.changePassword,
                    onTap: () => context.push(AppRouter.changePassword),
                  ),
                  _ProfileItem(
                    icon: Icons.language_rounded,
                    title: l10n.appLanguage,
                    onTap: () => _showLanguagePicker(context, l10n),
                  ),
                  _ProfileItem(
                    icon: Icons.help_outline_rounded,
                    title: l10n.helpSupport,
                    onTap: () => _showHelpSupport(context, l10n),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(label: l10n.ledgerPreferences),
                  const SizedBox(height: 8),
                  _ProfileItem(
                    icon: Icons.auto_awesome_rounded,
                    title: l10n.autoConfirmEntries,
                    onTap: () => context.push(AppRouter.ledgerPreferences),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(label: l10n.legalInfo),
                  const SizedBox(height: 8),
                  _ProfileItem(
                    icon: Icons.description_outlined,
                    title: l10n.termsAndConditions,
                    onTap: () => context.push(
                      AppRouter.policy,
                      extra: {
                        'title': l10n.termsAndConditions,
                        'endpoint': ApiEndpoints.termsAndConditions,
                      },
                    ),
                  ),
                  _ProfileItem(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy,
                    onTap: () => context.push(
                      AppRouter.policy,
                      extra: {
                        'title': l10n.privacyPolicy,
                        'endpoint': ApiEndpoints.privacyPolicy,
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () => _confirmLogout(context, l10n),
                    child: Text(
                      l10n.logout,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarSection(BuildContext context, UserModel? user) {
    return Column(
      children: [
        _buildAvatar(user),
        const SizedBox(height: 16),
        Text(user?.name ?? '...', style: AppTypography.h2),
        if (user?.mobile != null)
          Text(
            user!.mobile!,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        Text(
          user?.email ?? '',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
        ),
        if (user?.customerAddress != null && user!.customerAddress!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  user.customerAddress!,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textHint),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar(UserModel? user) {
    if (user?.profilePhotoUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(user!.profilePhotoUrl!),
      );
    }
    return const CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.customerAccent,
      child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languages = [
      {'locale': 'en', 'native': 'English', 'label': l10n.languageEnglish},
      {'locale': 'hi', 'native': 'हिन्दी', 'label': l10n.languageHindi},
      {'locale': 'bn', 'native': 'বাংলা', 'label': l10n.languageBengali},
      {'locale': 'mr', 'native': 'मराठी', 'label': l10n.languageMarathi},
      {'locale': 'ta', 'native': 'தமிழ்', 'label': l10n.languageTamil},
      {'locale': 'te', 'native': 'తెలుగు', 'label': l10n.languageTelugu},
      {'locale': 'kn', 'native': 'ಕನ್ನಡ', 'label': l10n.languageKannada},
      {'locale': 'gu', 'native': 'ગુજરાતી', 'label': l10n.languageGujarati},
      {'locale': 'pa', 'native': 'ਪੰਜਾਬੀ', 'label': l10n.languagePunjabi},
      {'locale': 'ml', 'native': 'മലയാളം', 'label': l10n.languageMalayalam},
      {'locale': 'hi', 'native': 'भोजपुरी', 'label': l10n.languageBhojpuri},
      {'locale': 'hi', 'native': 'मैथिली', 'label': l10n.languageMaithili},
    ];
    final currentCode = localeProvider.locale.languageCode;
    final initialIndex =
        languages.indexWhere((l) => l['locale'] == currentCode).clamp(0, languages.length - 1);
    int selectedIndex = initialIndex;
    final controller = FixedExtentScrollController(initialItem: initialIndex);

    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'language-picker',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8 * animation.value,
            sigmaY: 8 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: curved, child: child),
          ),
        );
      },
      pageBuilder: (ctx, anim, secondAnim) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.selectLanguage, style: AppTypography.h3),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  controller: controller,
                  itemExtent: 52,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) => selectedIndex = index,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: languages.length,
                    builder: (_, index) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(languages[index]['native']!,
                              style: AppTypography.labelLarge.copyWith(fontSize: 16)),
                          Text(languages[index]['label']!,
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        localeProvider.setLocale(
                          Locale(languages[selectedIndex]['locale']!),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.doneLabel,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.helpSupport),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mail_outline_rounded, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              l10n.helpSupportContactPrefix,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'igurus@info.in',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textHint,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.bodyLarge),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
