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

  Widget _getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 30,
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    //TODO Показать QR сплита
                    child: Container(
                        color: const Color.fromRGBO(255, 132, 0, 1.0)),
                  ),
                  Expanded(
                    //TODO sttings
                    child: Container(color: const Color.fromRGBO(0, 0, 0, 1.0)),
                  ),
                ]),
              ),
              Expanded(child: Scanner()),
              Container(
                  height: 30, color: const Color.fromRGBO(255, 132, 0, 1.0)),
            ]),
      ),
    );
  }
}
