import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:saath_khata/core/router/app_router.dart';

/// Guards the router's redirect decision.
///
/// The `locationPicker` case is a regression test: the picker used to be lumped
/// in with the pre-login routes, so a signed-in user who tapped "Tap to pick on
/// map" was redirected to the vendor shell. Because the push was imperative and
/// the redirect target lives inside a ShellRoute, go_router produced two pages
/// with the same key and the app died with:
///
///   'package:flutter/src/widgets/navigator.dart':
///   Failed assertion: line 4096 pos 18: '!keyReservation.contains(key)'
void main() {
  group('AppRouter.resolveRedirect', () {
    test('signed-in users may open the map picker (no redirect)', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: true,
          location: AppRouter.locationPicker,
        ),
        isNull,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: true,
          isVendor: false,
          location: AppRouter.locationPicker,
        ),
        isNull,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: false, // customer
          location: AppRouter.locationPicker,
        ),
        isNull,
      );
    });

    test('signed-out users may open the map picker (signup flow)', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: false,
          isUnauthenticated: true,
          isStaff: false,
          isVendor: false,
          location: AppRouter.locationPicker,
        ),
        isNull,
      );
    });

    test('signed-in users are bounced off the pre-login screens', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: true,
          location: AppRouter.phoneEntry,
        ),
        AppRouter.vendorHome,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: true,
          isVendor: false,
          location: AppRouter.otpVerify,
        ),
        AppRouter.staffHome,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: false,
          location: AppRouter.onboarding,
        ),
        AppRouter.customerHome,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: true,
          location: '${AppRouter.profileSetup}/vendor',
        ),
        AppRouter.vendorHome,
      );
    });

    test('signed-out users are blocked from protected screens', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: false,
          isUnauthenticated: true,
          isStaff: false,
          isVendor: false,
          location: AppRouter.vendorHome,
        ),
        AppRouter.roleSelection,
      );
    });

    test('signed-out users keep the pre-login flow', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: false,
          isUnauthenticated: true,
          isStaff: false,
          isVendor: false,
          location: AppRouter.phoneEntry,
        ),
        isNull,
      );
    });

    test('signed-in users are not redirected off protected screens', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: true,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: true,
          location: AppRouter.editProfile,
        ),
        isNull,
      );
    });

    test('pending auth states (initial/loading) never redirect', () {
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: false,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: false,
          location: AppRouter.splash,
        ),
        isNull,
      );
      expect(
        AppRouter.resolveRedirect(
          isAuthenticated: false,
          isUnauthenticated: false,
          isStaff: false,
          isVendor: false,
          location: AppRouter.vendorHome,
        ),
        isNull,
      );
    });
  });

  /// End-to-end version of the same regression: a signed-in vendor pushes the
  /// map picker from Edit Profile. With the old redirect this threw
  /// `'!keyReservation.contains(key)'`; now the picker opens.
  testWidgets('signed-in vendor can push the map picker', (tester) async {
    late GoRouter router;
    router = GoRouter(
      initialLocation: AppRouter.vendorHome,
      redirect: (context, state) => AppRouter.resolveRedirect(
        isAuthenticated: true,
        isUnauthenticated: false,
        isStaff: false,
        isVendor: true,
        location: state.uri.path,
      ),
      routes: [
        ShellRoute(
          builder: (c, s, child) => Scaffold(body: child),
          routes: [
            GoRoute(
              path: AppRouter.vendorHome,
              builder: (c, s) => const Center(child: Text('vendor home')),
            ),
          ],
        ),
        GoRoute(
          path: AppRouter.editProfile,
          builder: (c, s) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => router.push<void>(AppRouter.locationPicker),
                child: const Text('tap to pick on map'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRouter.locationPicker,
          builder: (c, s) => const Scaffold(body: Text('map picker')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    router.push<void>(AppRouter.editProfile);
    await tester.pumpAndSettle();

    await tester.tap(find.text('tap to pick on map'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('map picker'), findsOneWidget);
  });
}
