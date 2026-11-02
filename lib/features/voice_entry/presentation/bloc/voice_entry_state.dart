import '../../domain/models/voice_draft.dart';

sealed class VoiceEntryState {
  const VoiceEntryState();
}

class VoiceIdle extends VoiceEntryState {
  const VoiceIdle();
}

/// Mic is open; [partial] is the live transcript so far.
/// [soundLevel] is the latest dB reading from the mic (roughly -2 to +10).
class VoiceListening extends VoiceEntryState {
  final String partial;
  final double soundLevel;
  const VoiceListening(this.partial, {this.soundLevel = 0.0});
}

/// Transcript captured, waiting on the backend LLM.
class VoiceParsing extends VoiceEntryState {
  final String transcript;
  const VoiceParsing(this.transcript);
}

/// LLM returned a draft for the user to review / edit / confirm.
class VoiceReview extends VoiceEntryState {
  final VoiceDraft draft;
  const VoiceReview(this.draft);
}

class VoiceErrorState extends VoiceEntryState {
  final String message;
  const VoiceErrorState(this.message);
}
