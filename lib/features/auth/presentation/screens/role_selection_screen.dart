import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/primary_button.dart';
import 'role_selection_screen/widgets/role_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _vendorSelected = false;
  bool _customerSelected = false;

  bool get _canContinue => _vendorSelected || _customerSelected;

  void _onContinue() {
    final role = _vendorSelected ? 'vendor' : 'customer';
    context.push(AppRouter.phoneEntry, extra: role);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bothSelected = _vendorSelected && _customerSelected;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(l10n.welcomeToSaathKhata, style: AppTypography.h1),
              const SizedBox(height: 8),
              Text(
                l10n.tellUsHowYouUse,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // ── Vendor card ────────────────────────────────────────────────
              RoleCard(
                title: l10n.vendorRoleTitle,
                subtitle: l10n.vendorRoleSubtitle,
                icon: Icons.storefront_rounded,
                color: AppColors.primary,
                isSelected: _vendorSelected,
                onTap: () => setState(() => _vendorSelected = !_vendorSelected),
              ),
              const SizedBox(height: 20),

              // ── Customer card ──────────────────────────────────────────────
              RoleCard(
                title: l10n.customerRoleTitle,
                subtitle: l10n.customerRoleSubtitle,
                icon: Icons.person_search_rounded,
                color: AppColors.customerAccent,
                isSelected: _customerSelected,
                onTap: () =>
                    setState(() => _customerSelected = !_customerSelected),
              ),

              // ── Hint when both are selected ────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: bothSelected
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.dualRoleExplanation,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const Spacer(),

              // ── Continue button ────────────────────────────────────────────
              PrimaryButton(
                label: l10n.continueButton,
                onPressed: _canContinue ? _onContinue : null,
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.tagline,
                  style: AppTypography.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
