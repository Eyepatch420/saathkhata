import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saath_khata/core/services/storage_service.dart';
import 'package:saath_khata/features/auth/domain/otp_send_origin.dart';
import 'package:saath_khata/features/auth/domain/otp_send_result.dart';
import 'package:saath_khata/features/auth/domain/repositories/auth_repository.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_event.dart';
import 'package:saath_khata/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageService extends Mock implements StorageService {}

/// The OTP send path is shared by two screens through one app-scoped bloc.
/// These tests pin the two properties that keep the navigation sane:
///  - the number is normalised before it reaches the API, and
///  - the screen that asked for the code is carried through to the state.
void main() {
  late MockAuthRepository authRepository;
  late MockStorageService storage;

  setUp(() {
    authRepository = MockAuthRepository();
    storage = MockStorageService();
    when(() => authRepository.sendOtp(phone: any(named: 'phone'))).thenAnswer(
      (_) async => const OtpSendResult(
        expiresInSeconds: 300,
        resendAfterSeconds: 60,
        codeLength: 5,
      ),
    );
  });

  AuthBloc buildBloc() =>
      AuthBloc(authRepository: authRepository, storage: storage);

  group('AuthOtpSendRequested', () {
    blocTest<AuthBloc, AuthState>(
      'normalises +91/spaces and marks the first send as coming from the number screen',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthOtpSendRequested(phone: '+91 96502 63185')),
      expect: () => [
        const AuthLoading(),
        const AuthOtpSent(
          phone: '9650263185',
          resendAfterSeconds: 60,
          codeLength: 5,
          origin: OtpSendOrigin.phoneEntry,
        ),
      ],
      verify: (_) {
        verify(() => authRepository.sendOtp(phone: '9650263185')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'a resend is marked as such so the buried number screen cannot navigate',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const AuthOtpSendRequested(
          phone: '09650263185',
          origin: OtpSendOrigin.resend,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthOtpSent(
          phone: '9650263185',
          resendAfterSeconds: 60,
          codeLength: 5,
          origin: OtpSendOrigin.resend,
        ),
      ],
      verify: (_) {
        verify(() => authRepository.sendOtp(phone: '9650263185')).called(1);
      },
    );
  });
}
