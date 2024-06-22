import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splitti/widgets/text.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.date,
  });

  final ValueNotifier<DateTime> date;

  Future<void> _selectDate(
    BuildContext context,
    ValueNotifier<DateTime> date,
  ) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(2023, 1),
      lastDate: DateTime(2043, 1),
    );
    date.value = selectedDate ?? date.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CText(
          'Datum: ${DateFormat('dd.MM.yyyy').format(date.value)}',
        ),
        IconButton(
          onPressed: () => _selectDate(context, date),
          icon: const Icon(
            Icons.calendar_month,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}
