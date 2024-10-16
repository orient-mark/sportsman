import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: _getBody(),
      ),
    );
  }

  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(255, 132, 0, 1.0),
  );

  Widget _getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    style: _buttonStyle,
                    onPressed: () {
                      Navigator.pushNamed(context, '/result');
                    },
                    child: const Text('Показать сплит',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                IconButton(
                  color: Colors.black,
                  iconSize: 32.0,
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    scannerController.stop();
                    await Navigator.pushNamed(context, '/settings');
                    if (!context.mounted) return;
                    unawaited(scannerController.start());
                  },
                ),
              ]),
              Expanded(child: Scanner(controller: scannerController)),
            ]),
      ),
    );
  }
}
