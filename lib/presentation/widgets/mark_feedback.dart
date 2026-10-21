import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Owned by the scanner screen. The sound is preloaded before the first scan.
class MarkFeedback {
  MarkFeedback() : _sound = _loadSound();

  final Future<AudioPool?> _sound;
  OverlayEntry? _entry;
  Completer<void>? _completion;
  bool _disposed = false;

  static Future<AudioPool?> _loadSound() async {
    try {
      return await AudioPool.create(
        source: AssetSource('audio/mark_success.wav'),
        maxPlayers: 1,
      );
    } catch (error) {
      debugPrint('Cannot prepare mark sound: $error');
      return null;
    }
  }

  Future<void> _playSound(Completer<void> completion) async {
    try {
      final sound = await _sound;
      if (!_disposed && identical(_completion, completion)) {
        await sound?.start(volume: 0.7);
      }
    } catch (error) {
      debugPrint('Cannot play mark sound: $error');
    }
  }

  Future<void> show(BuildContext context) {
    if (_disposed) return Future.value();
    dismiss();
    final completion = Completer<void>();
    _completion = completion;
    _entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: IgnorePointer(
          child: MarkSuccessAnimation(
            onStart: () => unawaited(_playSound(completion)),
            onComplete: dismiss,
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
    return completion.future;
  }

  void dismiss() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    final completion = _completion;
    _completion = null;
    if (completion != null && !completion.isCompleted) completion.complete();
  }

  Future<void> dispose() async {
    _disposed = true;
    dismiss();
    await (await _sound)?.dispose();
  }
}

/// One timeline: grow + draw (0–620 ms), pulse (620–1000), fade (1120–1400).
class MarkSuccessAnimation extends StatefulWidget {
  const MarkSuccessAnimation({
    super.key,
    this.onStart,
    this.onPulse,
    required this.onComplete,
  });

  final VoidCallback? onStart;
  final VoidCallback? onPulse;
  final VoidCallback onComplete;

  static const durationMilliseconds = 1400;
  static const drawStartMilliseconds = 84;
  static const pulseStartMilliseconds = 620;
  static const pulseDurationMilliseconds = 380;
  static const fadeStartMilliseconds = 1120;
  static const fadeDurationMilliseconds = 280;

  static const duration = Duration(milliseconds: durationMilliseconds);
  static const drawStart = drawStartMilliseconds / durationMilliseconds;
  static const pulseStart = pulseStartMilliseconds / durationMilliseconds;
  static const pulseDuration = pulseDurationMilliseconds / durationMilliseconds;
  static const fadeStart = fadeStartMilliseconds / durationMilliseconds;
  static const fadeDuration = fadeDurationMilliseconds / durationMilliseconds;

  static const pulseScaleAmplitude = 0.13;
  static const circleSize = 156.0;
  static const circleColor = Color(0xFF24B66B);
  static const shadowOpacity = 0.28;
  static const shadowBlurRadius = 30.0;
  static const shadowSpreadRadius = 4.0;

  @override
  State<MarkSuccessAnimation> createState() => _MarkSuccessAnimationState();
}

class _MarkSuccessAnimationState extends State<MarkSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pulsed = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: MarkSuccessAnimation.duration,
            animationBehavior: AnimationBehavior.preserve,
          )
          ..addListener(() {
            if (!_pulsed &&
                _controller.value >= MarkSuccessAnimation.pulseStart) {
              _pulsed = true;
              widget.onPulse?.call();
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) widget.onComplete();
          })
          ..forward();
    widget.onStart?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final t = _controller.value;
      final grow = Curves.easeOutCubic.transform(
        (t / MarkSuccessAnimation.pulseStart).clamp(0.0, 1.0),
      );
      final draw = Curves.easeInOut.transform(
        ((t - MarkSuccessAnimation.drawStart) /
                (MarkSuccessAnimation.pulseStart -
                    MarkSuccessAnimation.drawStart))
            .clamp(0.0, 1.0),
      );
      final pulse =
          ((t - MarkSuccessAnimation.pulseStart) /
                  MarkSuccessAnimation.pulseDuration)
              .clamp(0.0, 1.0);
      final scale =
          grow *
          (1 +
              MarkSuccessAnimation.pulseScaleAmplitude *
                  math.sin(math.pi * pulse));
      final opacity =
          1 -
          Curves.easeIn.transform(
            ((t - MarkSuccessAnimation.fadeStart) /
                    MarkSuccessAnimation.fadeDuration)
                .clamp(0.0, 1.0),
          );
      return Semantics(
        label: 'Отметка сохранена',
        liveRegion: true,
        child: Opacity(
          opacity: opacity,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: MarkSuccessAnimation.circleSize,
                height: MarkSuccessAnimation.circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MarkSuccessAnimation.circleColor,
                  boxShadow: [
                    BoxShadow(
                      color: MarkSuccessAnimation.circleColor.withValues(
                        alpha: MarkSuccessAnimation.shadowOpacity,
                      ),
                      blurRadius: MarkSuccessAnimation.shadowBlurRadius,
                      spreadRadius: MarkSuccessAnimation.shadowSpreadRadius,
                    ),
                  ],
                ),
                child: CustomPaint(painter: MarkCheckPainter(draw)),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// A straight two-segment check, drawn left → bottom → upper right.
class MarkCheckPainter extends CustomPainter {
  const MarkCheckPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.51)
      ..lineTo(size.width * 0.43, size.height * 0.68)
      ..lineTo(size.width * 0.76, size.height * 0.34);
    final metric = path.computeMetrics().single;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.063
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(MarkCheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
