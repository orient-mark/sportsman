import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sportsman/domain/state/home/home_state.dart';
import 'package:sportsman/internal/dependencies/home_module.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _chipController = TextEditingController();

  late HomeState _homeState;

  @override
  void initState() {
    super.initState();
    _homeState = HomeModule.homeState();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getRowInput(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setParticipant,
              child: Text('Ввести'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getParticipant,
              child: Text('Получить'),
            ),
            const SizedBox(height: 20),
            _getParticipantInfo(),
          ],
        ),
      ),
    );
  }

  Widget _getRowInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Имя'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _surnameController,
            decoration: InputDecoration(hintText: 'Фамилия'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _chipController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            decoration: InputDecoration(hintText: 'Номер чипа'),
          ),
        ),
      ],
    );
  }

  Widget _getParticipantInfo() {
    return Observer(
      builder: (_) {
        if (_homeState.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (_homeState.isGeted == false) return Container();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Имя: ${_homeState.participant.name}'),
            Text('Фамилия: ${_homeState.participant.surname}'),
            Text('Чип: ${_homeState.participant.chip}'),
          ],
        );
      },
    );
  }

  void _getParticipant() {
    // здесь получаем данные
    _homeState.getParticipant();
  }

  void _setParticipant() {
    // здесь отправляем данные
    final name = _nameController.text;
    final surname = _surnameController.text;
    final chip = int.parse(_chipController.text);
    _homeState.setParticipant(name, surname, chip);
  }
}
