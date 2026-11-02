/// Which screen asked for an OTP.
///
/// `AuthBloc` is app-scoped (see `main.dart`), so *every* mounted screen that
/// listens to it sees the same `AuthOtpSent`. Without this marker the phone
/// screen — which stays alive underneath the OTP route — would push a second
/// OTP screen whenever the OTP screen resends, and pressing back would then walk
/// through duplicated OTP screens before reaching the number screen.
enum OtpSendOrigin {
  /// The number screen asked for the first code: navigate to the OTP screen.
  phoneEntry,

  /// The OTP screen asked for a replacement code: stay put and restart the
  /// countdown. It must never navigate.
  resend,
}
