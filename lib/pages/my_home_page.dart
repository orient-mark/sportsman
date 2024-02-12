import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.amber,
        constraints: const BoxConstraints(maxWidth: 400),
        child: const MyModalBottomSheet(),
      ),
    );
  }
}

class MyModalBottomSheet extends StatelessWidget {
  const MyModalBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Новое событие',
                      style: TextStyle(
                          color: Color.fromRGBO(11, 11, 11, 1),
                          //TODO fontFamily:
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.02,
                          fontSize: 32,
                          height: 1.43),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Для создания трасс и меток необходимо \nактивное событие, пожалуйста, \nсоздайте новое событие',
                      style: TextStyle(
                          color: Color.fromRGBO(11, 11, 11, 0.6),
                          //TODO fontFamily:
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.02,
                          fontSize: 14,
                          height: 1.43),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(11, 11, 11, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 17),
                    Text(
                      'Создать событие',
                      style: TextStyle(
                          color: Colors.white,
                          //TODO fontFamily:
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.43),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 47)
            ],
          ),
        ),
      ),
    );
  }
}
