import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/ledger_bloc.dart';
import 'shared_ledger_screen/widgets/ledger_list.dart';

/// Consolidated list of order deliveries for a link, shown to vendor, customer
/// and staff. Reuses the existing LedgerBloc (passed via BlocProvider.value) and
/// filters to auto-created order delivery entries only.
class DeliveriesScreen extends StatelessWidget {
  final String linkId;
  final String customerName;
  final String currentUserId;
  final bool isVendorView;
  final bool isStaffView;

  const DeliveriesScreen({
    super.key,
    required this.linkId,
    required this.customerName,
    required this.currentUserId,
    required this.isVendorView,
    this.isStaffView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deliveriesTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider.value(
        value: context.read<LedgerBloc>(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.deliveriesHint,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LedgerList(
                linkId: linkId,
                customerName: customerName,
                currentUserId: currentUserId,
                isVendorView: isVendorView,
                isStaffView: isStaffView,
                filterDeliveriesOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
