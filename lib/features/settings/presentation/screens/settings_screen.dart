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
import '../../../memberships/domain/repositories/membership_repository.dart';
import '../../../../core/di/injection.dart';
import '../widgets/delete_account_flow.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLang = localeProvider.locale.languageCode == 'hi'
        ? l10n.languageHindi
        : l10n.languageEnglish;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewPadding.bottom + 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 24),
              _SectionLabel(label: l10n.accountInformation),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                title: l10n.editProfile,
                subtitle: l10n.updateProfileDetails,
                onTap: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.push(AppRouter.editProfile,
                        extra: authState.user);
                  }
                },
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                title: l10n.changePassword,
                subtitle: l10n.updateAccountPassword,
                onTap: () => context.push(AppRouter.changePassword),
              ),
              _SettingsTile(
                icon: Icons.delete_outline_rounded,
                title: l10n.deleteAccount,
                subtitle: l10n.deleteAccountSubtitle,
                onTap: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    DeleteAccountFlow.start(context, authState.user);
                  }
                },
                isDanger: true,
              ),
              const SizedBox(height: 12),
              _SectionLabel(label: l10n.accountSettings),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: l10n.appLanguage,
                subtitle: currentLang,
                onTap: () => _showLanguagePicker(context, l10n, localeProvider),
              ),
              _SettingsTile(
                icon: Icons.account_balance_wallet_rounded,
                title: l10n.myUpiIds,
                subtitle: l10n.settingsManagePayments,
                onTap: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.push(AppRouter.upiManagement,
                        extra: authState.user);
                  }
                },
              ),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                title: l10n.helpSupport,
                subtitle: l10n.settingsFaqsContact,
                onTap: () {},
              ),
              // ─── Memberships (vendor only) ─────────────────────────────────
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (_, s) => s is AuthAuthenticated,
                builder: (context, authState) {
                  final user =
                      authState is AuthAuthenticated ? authState.user : null;
                  if (user == null || !user.isVendor) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      _SectionLabel(label: l10n.membershipsLabel),
                      const SizedBox(height: 8),
                      _SettingsTile(
                        icon: Icons.workspace_premium_rounded,
                        title: l10n.membershipPlansTitle,
                        subtitle: l10n.membershipPlansSubtitle,
                        onTap: () => context.push(AppRouter.membershipPlans),
                      ),
                      _SettingsTile(
                        icon: Icons.people_alt_rounded,
                        title: l10n.membersTitle,
                        subtitle: l10n.membersSubtitle,
                        onTap: () => context.push(AppRouter.membersDashboard),
                      ),
                      const _MembershipRequestsTile(),
                    ],
                  );
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (_, s) => s is AuthAuthenticated,
                builder: (context, authState) {
                  final user = authState is AuthAuthenticated ? authState.user : null;
                  if (user == null || user.isVendor) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      _SectionLabel(label: l10n.ledgerPreferences),
                      const SizedBox(height: 8),
                      _SettingsTile(
                        icon: Icons.auto_awesome_rounded,
                        title: l10n.autoConfirmEntries,
                        subtitle: l10n.autoConfirmSettingsSubtitle,
                        onTap: () => context.push(AppRouter.ledgerPreferences),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _SectionLabel(label: l10n.legalInfo),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: l10n.termsAndConditions,
                subtitle: l10n.readTermsOfService,
                onTap: () => context.push(
                  AppRouter.policy,
                  extra: {
                    'title': l10n.termsAndConditions,
                    'endpoint': ApiEndpoints.termsAndConditions,
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                subtitle: l10n.privacyPolicyDescription,
                onTap: () => context.push(
                  AppRouter.policy,
                  extra: {
                    'title': l10n.privacyPolicy,
                    'endpoint': ApiEndpoints.privacyPolicy,
                  },
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return TextButton(
                    onPressed: isLoading
                        ? null
                        : () => _confirmLogout(context, l10n),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            l10n.logout,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(l10n.settingsVersion('1.0.0'),
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
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

  void _showLanguagePicker(
      BuildContext context, AppLocalizations l10n, LocaleProvider provider) {
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
      {'locale': 'bho', 'native': 'भोजपुरी', 'label': l10n.languageBhojpuri},
      {'locale': 'mai', 'native': 'मैथिली', 'label': l10n.languageMaithili},
    ];
    final currentCode = provider.locale.languageCode;
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
      transitionBuilder: (ctx, animation, _, child) {
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
                        provider.setLocale(
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
                      child: Text(l10n.done,
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
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (_, current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _buildAvatar(user),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? '...', style: AppTypography.h3),
                    if (user?.email.isNotEmpty == true)
                      Text(user!.email, style: AppTypography.bodySmall),
                    if (user?.businessCategory?.isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user!.businessCategory!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (user != null)
                IconButton(
                  onPressed: () =>
                      context.push(AppRouter.editProfile, extra: user),
                  icon: const Icon(Icons.edit_rounded, size: 20),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(UserModel? user) {
    if (user?.profilePhotoUrl != null) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(user!.profilePhotoUrl!),
      );
    }
    return const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.error : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: Theme.of(context).colorScheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: color),
        title: Text(title,
            style: AppTypography.labelLarge.copyWith(
                color: isDanger ? AppColors.error : null)),
        subtitle: Text(subtitle, style: AppTypography.bodySmall),
        trailing:
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      ),
    );
  }
}

/// Shows a "Membership Requests" settings tile with a live pending-count badge.
/// Uses a FutureBuilder so it fetches once on mount — lightweight, no extra BLoC.
class _MembershipRequestsTile extends StatefulWidget {
  const _MembershipRequestsTile();

  @override
  State<_MembershipRequestsTile> createState() => _MembershipRequestsTileState();
}

class _MembershipRequestsTileState extends State<_MembershipRequestsTile> {
  late Future<int> _pendingCount;

  @override
  void initState() {
    super.initState();
    _pendingCount = _fetchCount();
  }

  Future<int> _fetchCount() async {
    try {
      final requests = await getIt<MembershipRepository>().getPendingRequests();
      return requests.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<int>(
      future: _pendingCount,
      builder: (context, snap) {
        final count = snap.data ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () => context.push(AppRouter.membershipRequests),
            tileColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.how_to_reg_rounded, color: AppColors.primary),
            title: Text(l10n.membershipRequestsTitle,
                style: AppTypography.labelLarge),
            subtitle: Text(
              count > 0
                  ? l10n.pendingRequestsSummary(count)
                  : l10n.noPendingRequests,
              style: AppTypography.bodySmall,
            ),
            trailing: count > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ),
        );
      },
    );
  }
}
