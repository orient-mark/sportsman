import 'package:flutter/material.dart';
import 'package:result_transfer/result_transfer.dart';

String formatInterval(Duration? value) {
  if (value == null) return '—';
  final ms = value.inMilliseconds.abs();
  final hours = ms ~/ 3600000;
  final minutes = (ms ~/ 60000 % 60).toString().padLeft(2, '0');
  final seconds = (ms ~/ 1000 % 60).toString().padLeft(2, '0');
  final fraction = (ms % 1000).toString().padLeft(3, '0');
  return '${value.isNegative ? '-' : ''}$hours:$minutes:$seconds.$fraction';
}

String formatClock(DateTime? value) {
  if (value == null) return 'Нет отметки';
  return value.toLocal().toIso8601String().replaceFirst('T', ' ');
}

class SplitView extends StatelessWidget {
  final ResultDocument document;
  const SplitView({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final start = document.start;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${document.surname} ${document.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text('Номер: ${document.chip}'),
        const SizedBox(height: 16),
        Text('Старт: ${formatClock(start)}'),
        Text('Финиш: ${formatClock(document.finish)}'),
        Text(
          'Общее время: ${formatInterval(start == null ? null : document.finish.difference(start))}',
        ),
        Text('Отметок КП: ${document.marks.length}'),
        const SizedBox(height: 16),
        if (start == null)
          const Text(
            'Без отметки старта общее время и время от старта недоступны. '
            'Интервалы между КП показаны по сохранённым отметкам.',
          ),
        if (document.marks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('Нет отметок КП. Финиш сохранён.'),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('№')),
                DataColumn(label: Text('КП')),
                DataColumn(label: Text('Время отметки')),
                DataColumn(label: Text('Интервал')),
                DataColumn(label: Text('От старта')),
              ],
              rows: [
                for (var i = 0; i < document.marks.length; i++)
                  DataRow(
                    cells: [
                      DataCell(Text('${i + 1}')),
                      DataCell(Text(document.marks[i].code)),
                      DataCell(Text(formatClock(document.marks[i].time))),
                      DataCell(
                        Text(
                          formatInterval(
                            i == 0
                                ? (start == null
                                      ? null
                                      : document.marks[i].time.difference(
                                          start,
                                        ))
                                : document.marks[i].time.difference(
                                    document.marks[i - 1].time,
                                  ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          formatInterval(
                            start == null
                                ? null
                                : document.marks[i].time.difference(start),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        if (document.marks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Последний КП → финиш: ${formatInterval(document.finish.difference(document.marks.last.time))}',
            ),
          ),
      ],
    );
  }
}
