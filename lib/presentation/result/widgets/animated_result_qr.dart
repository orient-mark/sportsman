import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sportsman/presentation/result/widgets/qr.dart';

class AnimatedResultQr extends StatefulWidget {
  final List<String> frames;
  const AnimatedResultQr({super.key, required this.frames});

  @override
  State<AnimatedResultQr> createState() => _AnimatedResultQrState();
}

class _AnimatedResultQrState extends State<AnimatedResultQr>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _index = 0;
  int _intervalMs = 500;
  bool _paused = false;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    assert(widget.frames.isNotEmpty);
    WidgetsBinding.instance.addObserver(this);
    _schedule();
  }

  @override
  void didUpdateWidget(covariant AnimatedResultQr oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.frames, widget.frames)) {
      _index = 0;
      _schedule();
    }
  }

  void _schedule() {
    _timer?.cancel();
    if (_paused || !_foreground || widget.frames.length < 2) return;
    _timer = Timer.periodic(Duration(milliseconds: _intervalMs), (_) {
      setState(() => _index = (_index + 1) % widget.frames.length);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = max(120.0, min(440.0, constraints.maxWidth - 32));
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'У организатора нажмите «Считать результат» и направьте камеру на этот QR.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: size,
              height: size,
              child: QrWidget(data: widget.frames[_index]),
            ),
            const SizedBox(height: 12),
            Text('Кадр ${_index + 1} из ${widget.frames.length}'),
            const Text(
              'Держите экран открытым до подтверждения на телефоне организатора.',
              textAlign: TextAlign.center,
            ),
            if (widget.frames.length > 1) ...[
              const SizedBox(height: 12),
              DropdownButton<int>(
                value: _intervalMs,
                items: const [
                  DropdownMenuItem(
                    value: 1000,
                    child: Text('Медленно · 1 кадр/с'),
                  ),
                  DropdownMenuItem(
                    value: 500,
                    child: Text('Обычно · 2 кадра/с'),
                  ),
                  DropdownMenuItem(
                    value: 250,
                    child: Text('Быстро · 4 кадра/с'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _intervalMs = value);
                  _schedule();
                },
              ),
              Wrap(
                spacing: 12,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                    label: Text(_paused ? 'Продолжить' : 'Пауза'),
                    onPressed: () {
                      setState(() => _paused = !_paused);
                      _schedule();
                    },
                  ),
                  if (_paused)
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _index = (_index + 1) % widget.frames.length;
                      }),
                      child: const Text('Следующий кадр'),
                    ),
                ],
              ),
            ],
          ],
        ),
      );
    },
  );
}
