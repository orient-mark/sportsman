import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  const CenterCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        value: 32.0,
        color: Color.fromRGBO(255, 132, 0, 1.0),
      ),
    );
  }
}
