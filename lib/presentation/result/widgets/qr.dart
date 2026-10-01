import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrWidget extends StatelessWidget {
  final String data;
  const QrWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: PrettyQrView(
        key: ValueKey(data),
        qrImage: QrImage(
          QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M),
        ),
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSquaresSymbol(color: Colors.black),
        ),
      ),
    ),
  );
}
