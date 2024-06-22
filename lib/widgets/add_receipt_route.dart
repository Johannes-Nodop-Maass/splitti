import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/state/receipts_cubit.dart';
import 'package:splitti/widgets/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:splitti/widgets/date_selector.dart';
import 'package:splitti/widgets/recurrence_dropdown_menu.dart';
import 'package:splitti/widgets/text.dart';
import 'package:splitti/widgets/text_fields/price_text_field.dart';
import 'package:splitti/widgets/text_fields/purpose_text_field.dart';

import 'buttons/cancel_button.dart';

class AddReceiptRoute extends WBDraggableBottomSheetRoute<bool> {
  AddReceiptRoute()
      : super(
          builder: (_, __, ___) => const AddReceiptScreen(),
          expanded: false,
        );
}

class AddReceiptScreen extends HookWidget {
  const AddReceiptScreen({super.key});

  void _onDone(
    BuildContext context,
    double price,
    String name,
    DateTime date,
    Recurrence recurrence,
  ) {
    context.read<ReceiptsCubit>().add(
          Invoice(
            name: name,
            value: price,
            date: date,
            recurrence: recurrence,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final price = useState(0.0);
    final purpose = useState('');
    final date = useState(DateTime.now());
    final recurrence = useState(Recurrence.once);

    final priceController = useSyncedTextEditingController((value) =>
        price.value = double.tryParse(value.text.replaceAll(',', '.')) ?? 0.0);
    final purposeController = useSyncedTextEditingController(
      (value) => purpose.value = value.text,
    );

    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                PriceTextFieldField(controller: priceController),
                const SizedBox(height: 8),
                PurposeTextFieldField(controller: purposeController),
                const SizedBox(height: 8),
                RecurrenceDropdownMenu(recurrence: recurrence),
                const SizedBox(height: 8),
                DateSelector(date: date),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _onDone(
                    context,
                    price.value,
                    purpose.value,
                    date.value,
                    recurrence.value,
                  ),
                  child: const CText(
                    'Hinzufügen',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const CancelButton(),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
