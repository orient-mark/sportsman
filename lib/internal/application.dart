import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:sportsman/presentation/settings.dart';
import 'package:sportsman/presentation/home/home.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
