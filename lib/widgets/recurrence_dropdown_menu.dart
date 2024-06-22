import 'package:flutter/material.dart';
import 'package:splitti/extensions/iterable.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/widgets/text.dart';

class RecurrenceDropdownMenu extends StatelessWidget {
  const RecurrenceDropdownMenu({
    super.key,
    required this.recurrence,
  });

  final ValueNotifier<Recurrence> recurrence;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CText('Häufigkeit'),
        const Spacer(),
        DropdownMenu(
          initialSelection: Recurrence.values.first,
          onSelected: (value) => recurrence.value = value!,
          dropdownMenuEntries: Recurrence.values.mapListIndexed(
            (index, recurrence) => DropdownMenuEntry(
              value: Recurrence.values[index],
              label: recurrence.name,
            ),
          ),
        ),
      ],
    );
  }
}
