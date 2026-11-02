import 'package:flutter/material.dart';
import '../membership_theme.dart';

/// Small pill showing a customer's active plan name, for list tiles.
class MembershipPlanBadge extends StatelessWidget {
  final String name;
  const MembershipPlanBadge({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      constraints: const BoxConstraints(maxWidth: 110),
      decoration: BoxDecoration(
        color: MembershipTheme.purpleSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MembershipTheme.purple.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_rounded,
              size: 12, color: MembershipTheme.purple),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MembershipTheme.purpleDark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
