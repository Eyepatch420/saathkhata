import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';

class BalanceHero extends StatelessWidget {
  final double balance;
  const BalanceHero({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final hasBalance = balance > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasBalance
              ? [const Color(0xFFD32F2F), const Color(0xFFB71C1C)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.currentBalance,
            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(0)}',
            style: AppTypography.h1
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            hasBalance ? AppLocalizations.of(context)!.outstanding : AppLocalizations.of(context)!.balanceSettled,
            style:
                AppTypography.bodySmall.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
