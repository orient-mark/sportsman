import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.context,
    required this.title,
  });

  final BuildContext context;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            color: Colors.black,
            iconSize: 32.0,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(255, 132, 0, 1.0),
          ),
        ),
      ],
    );
  }
}
