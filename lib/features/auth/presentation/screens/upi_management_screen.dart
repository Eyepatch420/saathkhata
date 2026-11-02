import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/upi_id_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../../../shared/widgets/app_toast.dart';
import 'upi_management_screen/widgets/upi_empty_state.dart';
import 'upi_management_screen/widgets/upi_id_tile.dart';

const int _maxUpiIds = 5;

class UpiManagementScreen extends StatefulWidget {
  final UserModel user;
  const UpiManagementScreen({super.key, required this.user});

  @override
  State<UpiManagementScreen> createState() => _UpiManagementScreenState();
}

class _UpiManagementScreenState extends State<UpiManagementScreen> {
  late List<UpiEntry> _entries;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _entries = (widget.user.upiIds ?? [])
        .map(
          (u) =>
              UpiEntry(serverId: u.id, upiId: u.upiId, isPrimary: u.isPrimary),
        )
        .toList();
  }

  void _setPrimary(int index) {
    setState(() {
      for (var i = 0; i < _entries.length; i++) {
        _entries[i] = _entries[i].copyWith(isPrimary: i == index);
      }
    });
  }

  void _delete(int index) {
    setState(() {
      _entries.removeAt(index);
      if (_entries.isNotEmpty && !_entries.any((e) => e.isPrimary)) {
        _entries[0] = _entries[0].copyWith(isPrimary: true);
      }
    });
  }

  void _showAddDialog() {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.addUpiIdTitle),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: l10n.upiIdHint,
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              final value = ctrl.text.trim();
              if (!_isValidUpiId(value)) {
                AppToast.show(
                  ctx,
                  l10n.invalidUpiFormat,
                  type: ToastType.error,
                );
                return;
              }
              if (_entries.any((e) => e.upiId == value)) {
                AppToast.show(
                  ctx,
                  l10n.upiIdAlreadyAdded,
                  type: ToastType.warning,
                );
                return;
              }
              Navigator.pop(ctx);
              setState(() {
                final isFirstEntry = _entries.isEmpty;
                _entries.add(UpiEntry(upiId: value, isPrimary: isFirstEntry));
              });
            },
            child: Text(
              l10n.add,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidUpiId(String value) {
    if (value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+$').hasMatch(value);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final upiModels = _entries
          .map(
            (e) => UpiIdModel(
              id: e.serverId ?? '',
              upiId: e.upiId,
              isPrimary: e.isPrimary,
            ),
          )
          .toList();

      final updated = await getIt<AuthRepository>().updateProfile(
        upiIds: upiModels,
      );

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      context.read<AuthBloc>().add(AuthUserUpdated(updated));
      AppToast.show(
        context,
        l10n.upiIdsSavedSuccessfully,
        type: ToastType.success,
      );
      Navigator.pop(context);
    } on Exception catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canAdd = _entries.length < _maxUpiIds;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myUpiIds),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _isSaving
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _save,
                    child: Text(
                      l10n.save,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _entries.isEmpty
                  ? UpiEmptyState(onAdd: _showAddDialog)
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      children: [
                        Text(
                          l10n.primaryUpiInfo,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.primaryUpiDescription,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(_entries.length, (i) {
                          final entry = _entries[i];
                          return UpiIdTile(
                            entry: entry,
                            onSetPrimary: () => _setPrimary(i),
                            onDelete: _entries.length == 1
                                ? null
                                : () => _delete(i),
                          );
                        }),
                        const SizedBox(height: 8),
                        Text(
                          l10n.upiIdCounter(
                            _entries.length,
                            _maxUpiIds,
                          ),
                          style: AppTypography.bodySmall.copyWith(
                            color: canAdd
                                ? AppColors.textSecondary
                                : AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
            if (canAdd)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.of(context).padding.bottom + 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(AppLocalizations.of(context)!.addUpiId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
