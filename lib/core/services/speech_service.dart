import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../utils/app_logger.dart';

/// Thin wrapper around the on-device `speech_to_text` engine.
/// One lazy singleton (DI). Handles init (which also prompts for the mic
/// permission), locale resolution for the app's 12 languages, and listening.
class SpeechService {
  static const _m = 'Speech';
  final SpeechToText _stt = SpeechToText();
  bool _initialized = false;

  /// App language codes that have no on-device recognizer → use Hindi (same
  /// Devanagari script); the LLM normalizes the rest.
  static const Map<String, String> _fallback = {'bho': 'hi', 'mai': 'hi'};

  bool get isAvailable => _stt.isAvailable;
  bool get isListening => _stt.isListening;

  /// Initializes the engine and requests mic permission. Returns false if the
  /// device has no recognizer or the user denied permission.
  Future<bool> init() async {
    if (_initialized) return _stt.isAvailable;
    _initialized = await _stt.initialize(
      onError: (e) => AppLogger.w(_m, 'STT error: ${e.errorMsg} (permanent:${e.permanent})'),
      onStatus: (s) => AppLogger.v(_m, 'STT status: $s'),
    );
    AppLogger.i(_m, 'STT initialized: $_initialized');
    return _initialized;
  }

  /// Resolves the best on-device localeId for an app language code (e.g. 'hi' →
  /// 'hi_IN'). Falls back to Hindi for bho/mai, then to the device default.
  Future<String?> resolveLocaleId(String appLang) async {
    final target = _fallback[appLang] ?? appLang;
    try {
      final locales = await _stt.locales();
      // Match 'hi', 'hi_IN', 'hi-IN' etc.
      for (final l in locales) {
        final id = l.localeId.replaceAll('-', '_').toLowerCase();
        if (id == target || id.startsWith('${target}_')) return l.localeId;
      }
      final system = await _stt.systemLocale();
      return system?.localeId;
    } catch (e) {
      AppLogger.w(_m, 'resolveLocaleId failed: $e');
      return null;
    }
  }

  /// Starts listening. [onResult] fires with partial and final transcripts.
  /// [onSoundLevel] fires with mic amplitude in dB (roughly -2 to +10).
  Future<void> listen({
    required String? localeId,
    required void Function(String text, bool isFinal) onResult,
    void Function(double level)? onSoundLevel,
  }) async {
    await _stt.listen(
      onResult: (SpeechRecognitionResult r) =>
          onResult(r.recognizedWords, r.finalResult),
      onSoundLevelChange: onSoundLevel,
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stop() => _stt.stop();
  Future<void> cancel() => _stt.cancel();
}
