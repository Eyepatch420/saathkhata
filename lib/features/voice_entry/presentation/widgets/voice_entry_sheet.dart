import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../shared_ledger/presentation/bloc/ledger_bloc.dart';
import '../../../shared_ledger/presentation/bloc/ledger_event.dart';
import '../../domain/models/voice_draft.dart';
import '../../domain/repositories/voice_repository.dart';
import '../bloc/voice_entry_cubit.dart';
import '../bloc/voice_entry_state.dart';

// ─── Background color used across all states in the dialog ───────────────────
const _kCardBg = Color(0xFF1A2E3D);

/// Shows the voice-entry dialog. The background blurs and dims.
Future<void> showVoiceEntrySheet(
  BuildContext context, {
  required String linkId,
  required bool isVendorView,
  required String language,
  required LedgerBloc ledgerBloc,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (dialogContext) => _VoiceEntryBlurDialog(
      linkId: linkId,
      isVendorView: isVendorView,
      language: language,
      ledgerBloc: ledgerBloc,
    ),
  );
}

// ─── Root: blur backdrop + centered dialog card ───────────────────────────────

class _VoiceEntryBlurDialog extends StatefulWidget {
  final String linkId;
  final bool isVendorView;
  final String language;
  final LedgerBloc ledgerBloc;

  const _VoiceEntryBlurDialog({
    required this.linkId,
    required this.isVendorView,
    required this.language,
    required this.ledgerBloc,
  });

  @override
  State<_VoiceEntryBlurDialog> createState() => _VoiceEntryBlurDialogState();
}

class _VoiceEntryBlurDialogState extends State<_VoiceEntryBlurDialog> {
  late final VoiceEntryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VoiceEntryCubit(
      speech: getIt<SpeechService>(),
      repo: getIt<VoiceRepository>(),
      linkId: widget.linkId,
      language: widget.language,
    )..startListening();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _confirm(VoiceDraft draft) {
    widget.ledgerBloc.add(AddLedgerEntry(
      amount: draft.amount,
      type: draft.type,
      linkId: widget.linkId,
      description: draft.description,
      quantity: draft.quantity,
      unit: draft.unit,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Stack(
        children: [
          // Blur + darken background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
          // Dialog card — centered, max width 400, scrollable for keyboard
          Center(
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: MediaQuery.of(context).viewInsets.bottom > 0
                        ? MediaQuery.of(context).viewInsets.bottom + 16
                        : 24,
                  ),
                  child: BlocBuilder<VoiceEntryCubit, VoiceEntryState>(
                    builder: (ctx, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: switch (state) {
                          VoiceListening() => _ListeningCard(
                              key: const ValueKey('listening'),
                              partial: state.partial,
                              soundLevel: state.soundLevel,
                              onStop: _cubit.stopListening,
                            ),
                          VoiceParsing() => _ParsingCard(
                              key: const ValueKey('parsing'),
                              transcript: state.transcript,
                            ),
                          VoiceReview() => _ReviewCard(
                              key: const ValueKey('review'),
                              draft: state.draft,
                              isVendorView: widget.isVendorView,
                              onConfirm: _confirm,
                              onRetry: _cubit.startListening,
                            ),
                          VoiceErrorState() => _ErrorCard(
                              key: const ValueKey('error'),
                              message: state.message,
                              onRetry: _cubit.startListening,
                              onCancel: () => Navigator.pop(context),
                            ),
                          VoiceIdle() => const _LoadingCard(key: ValueKey('idle')),
                        },
                    );
                  },
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

// ─── Listening card with real-time waveform ───────────────────────────────────

class _ListeningCard extends StatefulWidget {
  final String partial;
  final double soundLevel;
  final VoidCallback onStop;

  const _ListeningCard({
    super.key,
    required this.partial,
    required this.soundLevel,
    required this.onStop,
  });

  @override
  State<_ListeningCard> createState() => _ListeningCardState();
}

class _ListeningCardState extends State<_ListeningCard>
    with SingleTickerProviderStateMixin {
  // Rolling buffer of recent dB levels for the scrolling waveform.
  static const _barCount = 38;
  final List<double> _levels = List.filled(_barCount, 0.0, growable: true);
  late final AnimationController _idleAnim;

  @override
  void initState() {
    super.initState();
    // Idle pulse animation when no speech detected
    _idleAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_ListeningCard old) {
    super.didUpdateWidget(old);
    if (widget.soundLevel != old.soundLevel) {
      _levels.removeAt(0);
      _levels.add(widget.soundLevel);
    }
  }

  @override
  void dispose() {
    _idleAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.voiceListening,
            style: AppTypography.h3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 72,
            child: AnimatedBuilder(
              animation: _idleAnim,
              builder: (_, child) {
                return CustomPaint(
                  painter: _WaveformPainter(
                    // pass a copy so the painter sees the current snapshot
                    levels: List<double>.of(_levels),
                    idlePulse: _idleAnim.value,
                    color: AppColors.primary,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.partial.isEmpty ? '…' : '"${widget.partial}"',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: widget.onStop,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.stop_rounded,
                  color: AppColors.primary, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tapToStop,
            style: AppTypography.bodySmall.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

// ─── Real-time waveform painter ───────────────────────────────────────────────

class _WaveformPainter extends CustomPainter {
  final List<double> levels;
  final double idlePulse;
  final Color color;

  const _WaveformPainter({
    required this.levels,
    required this.idlePulse,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = levels.length;
    final totalBarWidth = size.width;
    final barWidth = (totalBarWidth / (n * 1.6)).clamp(3.0, 10.0);
    final gap = (totalBarWidth - barWidth * n) / (n - 1);
    final centerY = size.height / 2;
    final minHeight = 4.0;

    for (int i = 0; i < n; i++) {
      // Normalize: STT levels are typically -2 (silence) to +10 (loud)
      final raw = ((levels[i] + 2) / 12).clamp(0.0, 1.0);
      // Apply easing so quiet levels still show a small bar
      final normalized = raw < 0.05
          ? minHeight / size.height + idlePulse * 0.12 * math.sin(i * 0.4)
          : raw;

      final barHeight =
          (minHeight + (size.height - minHeight) * normalized).clamp(minHeight, size.height);

      final x = i * (barWidth + gap);
      final top = centerY - barHeight / 2;

      // Gradient opacity: newer bars are more opaque
      final opacity = 0.3 + 0.7 * (i / n);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, barWidth, barHeight),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// ─── Parsing card ─────────────────────────────────────────────────────────────

class _ParsingCard extends StatelessWidget {
  final String transcript;
  const _ParsingCard({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 20),
          Text(l10n.voiceThinking,
              style: AppTypography.h3.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text('"$transcript"',
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              )),
        ],
      ),
    );
  }
}

// ─── Error card ───────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  const _ErrorCard(
      {super.key,
      required this.message,
      required this.onRetry,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 40),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.tryAgain,
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Loading card ─────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({super.key});
  @override
  Widget build(BuildContext context) {
    return const _DialogCard(
      child: SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
    );
  }
}

// ─── Review / edit / confirm card ────────────────────────────────────────────

class _ReviewCard extends StatefulWidget {
  final VoiceDraft draft;
  final bool isVendorView;
  final void Function(VoiceDraft) onConfirm;
  final VoidCallback onRetry;

  const _ReviewCard({
    super.key,
    required this.draft,
    required this.isVendorView,
    required this.onConfirm,
    required this.onRetry,
  });

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  late final TextEditingController _amount;
  late final TextEditingController _desc;
  late final TextEditingController _qty;
  late EntryType _type;

  @override
  void initState() {
    super.initState();
    final d = widget.draft;
    _amount = TextEditingController(text: d.amount.toStringAsFixed(0));
    _desc = TextEditingController(text: d.description ?? '');
    _qty = TextEditingController(text: d.quantity?.toString() ?? '');
    _type = widget.isVendorView ? d.type : EntryType.payment;
  }

  @override
  void dispose() {
    _amount.dispose();
    _desc.dispose();
    _qty.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) return;
    widget.onConfirm(widget.draft.copyWith(
      amount: amount,
      type: _type,
      description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
      quantity: double.tryParse(_qty.text.trim()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use a dark-themed input decoration to match the dialog background
    final inputDecoration = InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F2027),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIconColor: Colors.white54,
    );

    return _DialogCard(
      padding: const EdgeInsets.all(20),
      child: Theme(
        data: Theme.of(context).copyWith(inputDecorationTheme: inputDecoration),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(l10n.voiceDetectedEntry,
                    style: AppTypography.bodySmall
                        .copyWith(color: Colors.white70)),
                const Spacer(),
                if (widget.draft.isLowConfidence)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(l10n.voicePleaseCheck,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.warning)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text('"${widget.draft.rawTranscript}"',
                style: AppTypography.bodySmall.copyWith(
                    color: Colors.white38, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            if (widget.isVendorView) ...[
              Row(
                children: [
                  Expanded(
                    child: _TypeChip(
                      label: l10n.giveCredit,
                      selected: _type == EntryType.credit,
                      color: AppColors.error,
                      onTap: () => setState(() => _type = EntryType.credit),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeChip(
                      label: l10n.recordPayment,
                      selected: _type == EntryType.payment,
                      color: AppColors.success,
                      onTap: () => setState(() => _type = EntryType.payment),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            TextField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.amountRupees,
                prefixIcon: const Icon(Icons.currency_rupee_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.descriptionOptional,
                prefixIcon: const Icon(Icons.description_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qty,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.quantityOptional,
                prefixIcon: const Icon(Icons.numbers_rounded),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.mic_rounded),
                  color: AppColors.primary,
                  tooltip: l10n.tryAgain,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.voiceConfirmEntry,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Type chip (entry type selector) ─────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : Colors.white12,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: selected ? color : Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Shared dialog card shell ─────────────────────────────────────────────────

class _DialogCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _DialogCard({
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
