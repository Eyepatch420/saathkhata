import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:saath_khata/core/di/injection.dart';
import 'package:saath_khata/core/localization/locale_provider.dart';
import 'package:saath_khata/core/services/storage_service.dart';
import 'package:saath_khata/features/auth/data/models/user_model.dart';
import 'package:saath_khata/features/auth/domain/delete_account_blocked_exception.dart';
import 'package:saath_khata/features/auth/domain/repositories/auth_repository.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_event.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_state.dart';
import 'package:saath_khata/features/memberships/domain/repositories/membership_repository.dart';
import 'package:saath_khata/features/settings/presentation/screens/settings_screen.dart';
import 'package:saath_khata/l10n/app_localizations.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageService extends Mock implements StorageService {}

class MockMembershipRepository extends Mock implements MembershipRepository {}

UserModel _user(String role, {String? mobile}) => UserModel(
      id: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      role: role,
      mobile: mobile,
      businessCategories: const [],
    );

Widget _wrap({required AuthBloc authBloc, required LocaleProvider localeProvider}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    builder: (context, child) => MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
      ],
      child: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    ),
  );
}

void main() {
  late MockStorageService storage;
  late LocaleProvider localeProvider;
  late MockMembershipRepository membershipRepository;
  late MockAuthRepository authRepository;

  setUpAll(() {
    registerFallbackValue(const AuthDeleteAccountRequested());
  });

  setUp(() {
    storage = MockStorageService();
    when(() => storage.getLocale()).thenReturn('en');
    when(() => storage.setLocale(any())).thenAnswer((_) async {});
    localeProvider = LocaleProvider(storage);

    membershipRepository = MockMembershipRepository();
    when(() => membershipRepository.getPendingRequests()).thenAnswer((_) async => []);
    if (getIt.isRegistered<MembershipRepository>()) {
      getIt.unregister<MembershipRepository>();
    }
    getIt.registerSingleton<MembershipRepository>(membershipRepository);

    authRepository = MockAuthRepository();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerSingleton<AuthRepository>(authRepository);
  });

  tearDown(() {
    if (getIt.isRegistered<MembershipRepository>()) {
      getIt.unregister<MembershipRepository>();
    }
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
  });

  for (final role in ['vendor', 'customer', 'staff']) {
    group('Settings screen delete-account flow — $role', () {
      testWidgets('shows a strong warning dialog before anything is dispatched', (tester) async {
        final authBloc = MockAuthBloc();
        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthAuthenticated(_user(role, mobile: '9876543210')),
        );

        await tester.pumpWidget(_wrap(authBloc: authBloc, localeProvider: localeProvider));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Account?'), findsOneWidget);
        expect(find.text('I Understand, Continue'), findsOneWidget);
        verifyNever(() => authBloc.add(const AuthDeleteAccountRequested()));
        verifyNever(() => authRepository.sendDeleteAccountOtp());
      });

      testWidgets('Cancel on the warning dialog dismisses without dispatching', (tester) async {
        final authBloc = MockAuthBloc();
        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthAuthenticated(_user(role, mobile: '9876543210')),
        );

        await tester.pumpWidget(_wrap(authBloc: authBloc, localeProvider: localeProvider));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Account?'), findsNothing);
        verifyNever(() => authBloc.add(const AuthDeleteAccountRequested()));
      });

      testWidgets(
          'full flow: warning -> type DELETE -> OTP -> dispatches AuthDeleteAccountRequested on success',
          (tester) async {
        final authBloc = MockAuthBloc();
        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthAuthenticated(_user(role, mobile: '9876543210')),
        );
        when(() => authRepository.sendDeleteAccountOtp()).thenAnswer((_) async {});
        when(() => authRepository.deleteAccount(confirmation: any(named: 'confirmation')))
            .thenAnswer((_) async {});

        await tester.pumpWidget(_wrap(authBloc: authBloc, localeProvider: localeProvider));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('I Understand, Continue'));
        await tester.pumpAndSettle();

        // Type-DELETE gate: "Delete Forever" starts disabled until typed correctly.
        expect(find.text('Type DELETE to confirm'), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'DELETE');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Forever'));
        await tester.pumpAndSettle();

        verify(() => authRepository.sendDeleteAccountOtp()).called(1);
        expect(find.text('Enter OTP'), findsOneWidget);

        await tester.enterText(find.byType(TextField).first, '123456');
        await tester.tap(find.text('Delete Forever'));
        await tester.pumpAndSettle();

        verify(() => authRepository.deleteAccount(confirmation: '123456')).called(1);
        verify(() => authBloc.add(const AuthDeleteAccountRequested())).called(1);
      });

      testWidgets('shows blockers and does not dispatch when the server refuses to delete',
          (tester) async {
        final authBloc = MockAuthBloc();
        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthAuthenticated(_user(role, mobile: '9876543210')),
        );
        when(() => authRepository.sendDeleteAccountOtp()).thenAnswer((_) async {});
        when(() => authRepository.deleteAccount(confirmation: any(named: 'confirmation')))
            .thenThrow(const DeleteAccountBlockedException([
          DeleteAccountBlocker(
              code: 'OUTSTANDING_BALANCE', message: 'Settle your outstanding balance first.'),
        ]));

        await tester.pumpWidget(_wrap(authBloc: authBloc, localeProvider: localeProvider));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete Account'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('I Understand, Continue'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, 'DELETE');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Forever'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, '123456');
        await tester.tap(find.text('Delete Forever'));
        await tester.pumpAndSettle();

        expect(find.text("Can't Delete Account Yet"), findsOneWidget);
        expect(find.text('Settle your outstanding balance first.'), findsOneWidget);
        verifyNever(() => authBloc.add(const AuthDeleteAccountRequested()));
      });
    });
  }

  group('Settings screen delete-account flow — email-only account (no phone)', () {
    testWidgets('skips OTP and asks for password instead', (tester) async {
      final authBloc = MockAuthBloc();
      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthAuthenticated(_user('vendor', mobile: null)),
      );
      when(() => authRepository.deleteAccount(confirmation: any(named: 'confirmation')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(_wrap(authBloc: authBloc, localeProvider: localeProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('I Understand, Continue'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'DELETE');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete Forever'));
      await tester.pumpAndSettle();

      verifyNever(() => authRepository.sendDeleteAccountOtp());
      expect(find.text('Enter your password'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'MyPassword123!');
      await tester.tap(find.text('Delete Forever'));
      await tester.pumpAndSettle();

      verify(() => authRepository.deleteAccount(confirmation: 'MyPassword123!')).called(1);
      verify(() => authBloc.add(const AuthDeleteAccountRequested())).called(1);
    });
  });
}
