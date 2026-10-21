import 'package:flutter/material.dart';
import 'package:sportsman/presentation/theme/app_theme.dart';
import 'package:result_transfer/result_transfer.dart';
import 'package:sportsman/presentation/formatters/display_date_time.dart';

class SplitView extends StatelessWidget {
  final ResultDocument document;
  final bool hasParticipantData;
  const SplitView({
    super.key,
    required this.document,
    this.hasParticipantData = true,
  });

  @override
  Widget build(BuildContext context) {
    final start = document.start;
    return ListView(
      padding: AppTheme.pagePadding,
      children: [
        Text(
          '${document.surname} ${document.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text('Номер: ${hasParticipantData ? document.chip : ''}'),
        const SizedBox(height: AppTheme.spaceLarge),
        Text('Старт: ${DisplayDateTime.dateTime(start)}'),
        Text('Финиш: ${DisplayDateTime.dateTime(document.finish)}'),
        Text(
          'Общее время: ${DisplayDateTime.interval(start == null ? null : document.finish?.difference(start))}',
        ),
        Text('Отметок КП: ${document.marks.length}'),
        const SizedBox(height: AppTheme.spaceLarge),
        if (start == null)
          const Text(
            'Без отметки старта общее время и время от старта недоступны. '
            'Интервалы между КП показаны по сохранённым отметкам.',
          ),
        if (document.marks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spaceSection,
            ),
            child: Text(
              document.finish == null
                  ? 'Нет отметок КП и финиша.'
                  : 'Нет отметок КП. Финиш сохранён.',
            ),
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
                      DataCell(
                        Text(DisplayDateTime.dateTime(document.marks[i].time)),
                      ),
                      DataCell(
                        Text(
                          DisplayDateTime.interval(
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
                          DisplayDateTime.interval(
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
            padding: const EdgeInsets.only(top: AppTheme.spaceLarge),
            child: Text(
              'Последний КП → финиш: ${DisplayDateTime.interval(document.finish?.difference(document.marks.last.time))}',
            ),
          ),
      ],
    );
  }
}
