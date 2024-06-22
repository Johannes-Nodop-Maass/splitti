import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/state/receipts_cubit.dart';
import 'package:splitti/widgets/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:splitti/widgets/buttons/cancel_button.dart';
import 'package:splitti/widgets/date_selector.dart';
import 'package:splitti/widgets/recurrence_dropdown_menu.dart';
import 'package:splitti/widgets/text.dart';
import 'package:splitti/widgets/text_fields/price_text_field.dart';
import 'package:splitti/widgets/text_fields/purpose_text_field.dart';

class EditReceiptRoute extends WBDraggableBottomSheetRoute<bool> {
  EditReceiptRoute(Invoice receipt)
      : super(
          builder: (_, __, ___) => EditReceiptScreen(receipt: receipt),
          expanded: false,
        );
}

class EditReceiptScreen extends HookWidget {
  const EditReceiptScreen({super.key, required this.receipt});

  final Invoice receipt;

  void _onDone(
    BuildContext context,
    double price,
    String name,
    DateTime date,
    Recurrence recurrence,
  ) {
    context.read<ReceiptsCubit>().edit(
          receipt,
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
    final price = useState(receipt.value);
    final purpose = useState(receipt.name);
    final date = useState(receipt.date);
    final recurrence = useState(receipt.recurrence);

    final priceController = useSyncedTextEditingController(
      (value) =>
          price.value = double.tryParse(value.text.replaceAll(',', '.')) ?? 0.0,
      initialText: receipt.value.toString(),
    );
    final purposeController = useSyncedTextEditingController(
      (value) => purpose.value = value.text,
      initialText: receipt.name,
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
                    'Speichern',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const CancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
