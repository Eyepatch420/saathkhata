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
/// These tests pin the properties that keep the navigation sane and the
/// challenge identity intact:
///  - the number is normalised before it reaches the API,
///  - the screen that asked for the code is carried through to the state,
///  - the install's device id is sent, and
///  - a resumed challenge is still a navigation event (never a cool-down error).
void main() {
  late MockAuthRepository authRepository;
  late MockStorageService storage;

  setUp(() {
    authRepository = MockAuthRepository();
    storage = MockStorageService();
    when(() => storage.getOrCreateOtpDeviceId()).thenAnswer((_) async => 'device-test-1234');
    when(
      () => authRepository.sendOtp(
        phone: any(named: 'phone'),
        deviceId: any(named: 'deviceId'),
      ),
    ).thenAnswer(
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
        verify(() => authRepository.sendOtp(phone: '9650263185', deviceId: 'device-test-1234'))
            .called(1);
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
        verify(() => authRepository.sendOtp(phone: '9650263185', deviceId: 'device-test-1234'))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'a resumed challenge still navigates and carries its id (no cool-down toast)',
      build: buildBloc,
      setUp: () {
        when(
          () => authRepository.sendOtp(
            phone: any(named: 'phone'),
            deviceId: any(named: 'deviceId'),
          ),
        ).thenAnswer(
          (_) async => const OtpSendResult(
            expiresInSeconds: 240,
            resendAfterSeconds: 31,
            codeLength: 5,
            challengeId: 'a3f1c2d4-0000-4000-8000-000000000001',
            resumed: true,
          ),
        );
      },
      act: (bloc) => bloc.add(const AuthOtpSendRequested(phone: '9650263185')),
      expect: () => [
        const AuthLoading(),
        const AuthOtpSent(
          phone: '9650263185',
          resendAfterSeconds: 31,
          codeLength: 5,
          origin: OtpSendOrigin.phoneEntry,
          challengeId: 'a3f1c2d4-0000-4000-8000-000000000001',
          resumed: true,
        ),
      ],
    );
  });
}
