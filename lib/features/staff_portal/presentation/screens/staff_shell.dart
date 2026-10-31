import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/animations/rive/app_rive_icon.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/staff_portal_cubit.dart';

/// Bottom-nav shell for the staff (labour) experience.
/// Four tabs — Home, Customers, Deliveries, My Pay. No staff management,
/// reports, settings, or add-customer affordances. Provides a shared
/// [StaffPortalCubit].
class StaffMainWrapper extends StatelessWidget {
  final Widget child;
  const StaffMainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StaffPortalCubit(getIt(), getIt())..load(),
      child: Scaffold(
        extendBody: true,
        body: child,
        bottomNavigationBar: Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx)!;
            return AppBottomNavBar(
              currentIndex: _selectedIndex(ctx),
              onTap: (i) => _onTap(ctx, i),
              items: [
                AppNavItem(riveIcon: AppRiveIcon.home, label: l10n.navHome),
                AppNavItem(riveIcon: AppRiveIcon.message, label: l10n.customersTitle),
                AppNavItem(riveIcon: AppRiveIcon.clock, label: l10n.deliveriesTitle),
                AppNavItem(riveIcon: AppRiveIcon.zap, label: l10n.myPay),
              ],
            );
          },
        ),
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc == AppRouter.staffCustomers) return 1;
    if (loc == AppRouter.staffDeliveries) return 2;
    if (loc == AppRouter.staffPay) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.staffHome);
        break;
      case 1:
        context.go(AppRouter.staffCustomers);
        break;
      case 2:
        context.go(AppRouter.staffDeliveries);
        break;
      case 3:
        context.go(AppRouter.staffPay);
        break;
    }
  }
}
