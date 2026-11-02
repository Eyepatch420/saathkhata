import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/delete_account_blocked_exception.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

/// Drives the full self-delete confirmation sequence for a financial-ledger
/// app: a strong warning, an explicit "type DELETE" confirmation, then
/// re-authentication (OTP for phone accounts, password for email-only
/// accounts) before calling the server. Blocker errors (outstanding
/// balance, active staff, etc) are shown so the user knows exactly what to
/// resolve first. Used from both the vendor/customer settings screen and
/// the staff self-service screen.
class DeleteAccountFlow {
  static Future<void> start(BuildContext context, UserModel user) async {
    final l10n = AppLocalizations.of(context)!;

    final understood = await _showWarningDialog(context, l10n, user);
    if (understood != true || !context.mounted) return;

    final typedDelete = await _showTypeDeleteDialog(context, l10n);
    if (typedDelete != true || !context.mounted) return;

    final hasPhone = (user.mobile ?? '').isNotEmpty;
    if (hasPhone) {
      final repo = getIt<AuthRepository>();
      try {
        await repo.sendDeleteAccountOtp();
      } catch (e) {
        if (context.mounted) {
          AppToast.show(context, e.toString().replaceFirst('Exception: ', ''),
              type: ToastType.error);
        }
        return;
      }
      if (!context.mounted) return;
    }

    await _showConfirmationInputDialog(context, l10n, hasPhone: hasPhone);
  }

  static Future<bool?> _showWarningDialog(
      BuildContext context, AppLocalizations l10n, UserModel user) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: AppColors.error, size: 32),
        title: Text(l10n.deleteAccountConfirmation),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAccountStrongWarning),
              const SizedBox(height: 12),
              _bullet(l10n.deleteAccountWarningLoginRemoved),
              _bullet(l10n.deleteAccountWarningIrreversible),
              _bullet(l10n.deleteAccountWarningRecordsKept),
              if (user.isVendor) _bullet(l10n.deleteAccountWarningVendorBlockers),
              if (user.isStaff) _bullet(l10n.deleteAccountWarningStaffBlockers),
              if (!user.isVendor && !user.isStaff)
                _bullet(l10n.deleteAccountWarningCustomerBlockers),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.iUnderstandContinue),
          ),
        ],
      ),
    );
  }

  static Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('•  '),
            Expanded(child: Text(text, style: AppTypography.bodySmall)),
          ],
        ),
      );

  static Future<bool?> _showTypeDeleteDialog(
      BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final isValid = controller.text.trim() == 'DELETE';
          return AlertDialog(
            title: Text(l10n.deleteAccountTypeToConfirmTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.deleteAccountTypeToConfirmMessage),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'DELETE',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: isValid ? () => Navigator.pop(ctx, true) : null,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(l10n.deleteForever),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _showConfirmationInputDialog(
    BuildContext context,
    AppLocalizations l10n, {
    required bool hasPhone,
  }) async {
    final controller = TextEditingController();
    bool isSubmitting = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> submit() async {
            final value = controller.text.trim();
            if (value.isEmpty) return;
            setState(() {
              isSubmitting = true;
              errorText = null;
            });
            try {
              await getIt<AuthRepository>().deleteAccount(confirmation: value);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                context.read<AuthBloc>().add(const AuthDeleteAccountRequested());
              }
            } on DeleteAccountBlockedException catch (e) {
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                await _showBlockersDialog(context, l10n, e.blockers);
              }
            } catch (e) {
              setState(() {
                isSubmitting = false;
                errorText = e.toString().replaceFirst('Exception: ', '');
              });
            }
          }

          return AlertDialog(
            title: Text(hasPhone
                ? l10n.deleteAccountEnterOtpTitle
                : l10n.deleteAccountEnterPasswordTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hasPhone
                    ? l10n.deleteAccountEnterOtpMessage
                    : l10n.deleteAccountEnterPasswordMessage),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  obscureText: !hasPhone,
                  keyboardType:
                      hasPhone ? TextInputType.number : TextInputType.visiblePassword,
                  maxLength: hasPhone ? 6 : null,
                  decoration: InputDecoration(
                    hintText: hasPhone ? '000000' : null,
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                  ),
                  enabled: !isSubmitting,
                  onSubmitted: (_) => submit(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: isSubmitting ? null : submit,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.deleteForever),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _showBlockersDialog(
    BuildContext context,
    AppLocalizations l10n,
    List<DeleteAccountBlocker> blockers,
  ) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.block_rounded, color: AppColors.error, size: 32),
        title: Text(l10n.deleteAccountBlockedTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAccountBlockedMessage),
              const SizedBox(height: 12),
              ...blockers.map((b) => _bullet(b.message)),
            ],
          ),
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
}
