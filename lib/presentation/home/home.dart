import 'package:flutter/material.dart';
import 'package:sportsman/presentation/home/widget/scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                      //TODO переход
                    },
                    child: const Text('Показать сплит',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                IconButton(
                  color: Colors.black,
                  iconSize: 32.0,
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    //TODO переход
                  },
                ),
              ]),
              Expanded(child: Scanner()),
            ]),
      ),
    );
  }
}
