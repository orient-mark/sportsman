import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrWidget extends StatefulWidget {
  final String data;

  const QrWidget({
    required this.data,
    super.key,
  });

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();

    final qrCode = QrCode.fromData(
      data: widget.data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return PrettyQrView(
      qrImage: qrImage,
    );
  }
}
