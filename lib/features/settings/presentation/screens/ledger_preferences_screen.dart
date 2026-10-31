import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/models/link_model.dart';
import '../../../customer/domain/repositories/customer_repository.dart';

class LedgerPreferencesScreen extends StatefulWidget {
  const LedgerPreferencesScreen({super.key});

  @override
  State<LedgerPreferencesScreen> createState() =>
      _LedgerPreferencesScreenState();
}

class _LedgerPreferencesScreenState extends State<LedgerPreferencesScreen> {
  static const _m = 'LedgerPreferences';
  bool _loading = true;
  String? _error;
  List<VendorLinkItem> _links = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final links = await getIt<CustomerRepository>().getLinkedVendors();
      AppLogger.i(_m, 'Loaded ${links.length} linked vendors');
      if (mounted) {
        setState(() {
          _links = links.where((l) => !l.isPending).toList();
          _loading = false;
        });
      }
    } catch (e) {
      AppLogger.e(_m, 'Failed to load linked vendors', e);
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  Future<void> _toggle(int index, bool value) async {
    final link = _links[index];
    // Optimistic update
    setState(() => _links[index] = link.copyWith(customerAutoConfirm: value));
    try {
      await getIt<CustomerRepository>().updateAutoConfirm(
        link.linkId,
        enabled: value,
      );
    } catch (e) {
      // Rollback on error
      if (mounted) {
        setState(
          () => _links[index] = link.copyWith(
            customerAutoConfirm: link.customerAutoConfirm,
          ),
        );
        AppToast.show(
          context,
          AppLocalizations.of(context)!.updatePreferenceFailed,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.ledgerPreferences)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? ErrorStateWidget(message: _error!, onRetry: _load)
          : _links.isEmpty
          ? Center(
              child: Text(
                  AppLocalizations.of(context)!.noLinkedVendorsYet))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _links.length,
              separatorBuilder: (context, i) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final link = _links[i];
                final vendorName = link.vendor.businessName ?? link.vendor.name;
                return SwitchListTile.adaptive(
                  secondary: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: link.vendor.profilePhotoUrl != null
                        ? NetworkImage(link.vendor.profilePhotoUrl!)
                        : null,
                    child: link.vendor.profilePhotoUrl == null
                        ? const Icon(
                            Icons.store_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  title: Text(vendorName),
                  subtitle: Text(
                    link.customerAutoConfirm
                        ? AppLocalizations.of(context)!
                            .autoConfirmingVendorEntries
                        : AppLocalizations.of(context)!
                            .manualConfirmationRequired,
                    style: TextStyle(
                      color: link.customerAutoConfirm
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  value: link.customerAutoConfirm,
                  onChanged: (val) => _toggle(i, val),
                  activeThumbColor: AppColors.primary,
                );
              },
            ),
    );
  }
}
