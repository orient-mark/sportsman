import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.context,
    required this.title,
    this.result,
  });

  final BuildContext context;
  final String title;
  final dynamic result;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context, result);
            },
          ),
        ),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
