import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saath_khata/core/di/injection.dart';
import 'package:saath_khata/core/services/ledger_socket_service.dart';
import 'package:saath_khata/core/services/storage_service.dart';
import 'package:saath_khata/features/auth/domain/repositories/auth_repository.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_event.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageService extends Mock implements StorageService {}

class MockLedgerSocketService extends Mock implements LedgerSocketService {}

void main() {
  late MockAuthRepository authRepository;
  late MockStorageService storage;
  late MockLedgerSocketService ledgerSocket;

  setUp(() {
    authRepository = MockAuthRepository();
    storage = MockStorageService();
    ledgerSocket = MockLedgerSocketService();

    if (getIt.isRegistered<LedgerSocketService>()) {
      getIt.unregister<LedgerSocketService>();
    }
    getIt.registerSingleton<LedgerSocketService>(ledgerSocket);

    when(() => ledgerSocket.disconnect()).thenReturn(null);
    when(() => storage.clearAll()).thenAnswer((_) async {});
  });

  tearDown(() {
    if (getIt.isRegistered<LedgerSocketService>()) {
      getIt.unregister<LedgerSocketService>();
    }
  });

  AuthBloc buildBloc() => AuthBloc(authRepository: authRepository, storage: storage);

  // The actual server-side deletion (OTP/password re-auth, blocker errors)
  // now happens in DeleteAccountFlow, which calls AuthRepository.deleteAccount
  // directly and only dispatches this event once the server has confirmed
  // deletion. The bloc's job here is just to clear the local session —
  // it must never fail, since the server call already succeeded.
  group('AuthDeleteAccountRequested', () {
    blocTest<AuthBloc, AuthState>(
      'clears local session and emits Unauthenticated without touching AuthRepository',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthDeleteAccountRequested()),
      expect: () => [const AuthUnauthenticated()],
      verify: (_) {
        verifyNever(() => authRepository.deleteAccount(confirmation: any(named: 'confirmation')));
        verify(() => storage.clearAll()).called(1);
        verify(() => ledgerSocket.disconnect()).called(1);
      },
    );
  });

  test('AuthDeleteAccountRequested is a stable const event with no payload', () {
    expect(const AuthDeleteAccountRequested(), equals(const AuthDeleteAccountRequested()));
  });
}
