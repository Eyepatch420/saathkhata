import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/staff_model.dart';
import '../../../../../../shared/widgets/app_toast.dart';
import '../../../../domain/repositories/staff_repository.dart';

/// Vendor-facing card on the staff detail screen to grant or revoke a staff
/// member's app login. Calls PATCH /staff/:id/access and reflects the result.
class AppAccessCard extends StatefulWidget {
  final StaffModel staff;
  const AppAccessCard({super.key, required this.staff});

  @override
  State<AppAccessCard> createState() => _AppAccessCardState();
}

class _AppAccessCardState extends State<AppAccessCard> {
  late bool _canLogin = widget.staff.canLogin;
  bool _loading = false;

  Future<void> _toggle(bool value) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final updated =
          await getIt<StaffRepository>().setAppAccess(widget.staff.id, value);
      if (!mounted) return;
      setState(() {
        _canLogin = updated.canLogin;
        _loading = false;
      });
      final l10n = AppLocalizations.of(context)!;
      AppToast.show(
        context,
        value
            ? l10n.appAccessGranted(widget.staff.name, widget.staff.phone)
            : l10n.appAccessRevoked(widget.staff.name),
        type: value ? ToastType.success : ToastType.info,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppToast.show(context, e.toString().replaceFirst('Exception: ', ''),
          type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phonelink_lock_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.appAccess, style: AppTypography.labelLarge),
                    Text(
                      _canLogin ? l10n.appAccessActive(widget.staff.phone) : l10n.appAccessDisabled,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (_loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Switch(
                  value: _canLogin,
                  activeThumbColor: AppColors.primary,
                  onChanged: _toggle,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.appAccessDescription(widget.staff.name, widget.staff.phone),
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textHint, height: 1.4),
          ),
        ],
      ),
    );
  }
}
