import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/models/voice_draft.dart';
import '../../domain/repositories/voice_repository.dart';
import 'voice_entry_state.dart';

/// Drives the voice-entry flow for one shared-ledger link:
/// idle → listening(partial) → parsing → review(draft) → (confirm handled by UI).
class VoiceEntryCubit extends Cubit<VoiceEntryState> {
  final SpeechService _speech;
  final VoiceRepository _repo;
  final String linkId;
  final String language;

  static const _m = 'VoiceCubit';
  String _lastWords = '';
  bool _parsing = false;

  VoiceEntryCubit({
    required SpeechService speech,
    required VoiceRepository repo,
    required this.linkId,
    required this.language,
  })  : _speech = speech,
        _repo = repo,
        super(const VoiceIdle());

  Future<void> startListening() async {
    _lastWords = '';
    _parsing = false;
    final ready = await _speech.init();
    if (!ready) {
      emit(const VoiceErrorState(
          'Microphone unavailable. Enable mic permission and on-device speech to use voice entry.'));
      return;
    }
    emit(const VoiceListening(''));
    final localeId = await _speech.resolveLocaleId(language);
    AppLogger.i(_m, 'Listening (lang:$language → locale:$localeId)');
    try {
      await _speech.listen(
        localeId: localeId,
        onResult: (text, isFinal) {
          _lastWords = text;
          if (state is VoiceListening) {
            emit(VoiceListening(text, soundLevel: (state as VoiceListening).soundLevel));
          }
          if (isFinal) _parse(text);
        },
        onSoundLevel: (level) {
          if (state is VoiceListening) {
            emit(VoiceListening((state as VoiceListening).partial, soundLevel: level));
          }
        },
      );
    } catch (e) {
      AppLogger.e(_m, 'listen failed', e);
      emit(const VoiceErrorState('Could not start listening. Please try again.'));
    }
  }

  /// User tapped the mic to stop early — settle with whatever we have.
  Future<void> stopListening() async {
    await _speech.stop();
    if (_lastWords.trim().isEmpty) {
      emit(const VoiceErrorState("Didn't catch that. Please try again."));
      return;
    }
    _parse(_lastWords);
  }

  Future<void> _parse(String transcript) async {
    if (_parsing) return; // guard against final-result + manual-stop double fire
    _parsing = true;
    final text = transcript.trim();
    if (text.isEmpty) {
      emit(const VoiceErrorState("Didn't catch that. Please try again."));
      return;
    }
    await _speech.stop();
    emit(VoiceParsing(text));
    try {
      final draft = await _repo.parse(linkId: linkId, transcript: text, language: language);
      emit(VoiceReview(draft));
    } catch (e) {
      AppLogger.e(_m, 'parse failed', e);
      emit(VoiceErrorState(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// User edited a field on the review card.
  void updateDraft(VoiceDraft draft) => emit(VoiceReview(draft));

  /// Reset to try the whole flow again.
  void reset() {
    _lastWords = '';
    _parsing = false;
    emit(const VoiceIdle());
  }

  @override
  Future<void> close() {
    _speech.cancel();
    return super.close();
  }
}
