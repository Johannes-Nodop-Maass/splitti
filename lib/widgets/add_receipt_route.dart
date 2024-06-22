import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/state/receipts_cubit.dart';
import 'package:splitti/widgets/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:splitti/widgets/text.dart';
import 'package:splitti/widgets/text_fields/price_text_field.dart';
import 'package:splitti/widgets/text_fields/purpose_text_field.dart';

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
    bool monthly,
  ) {
    context.read<ReceiptsCubit>().add(
          Invoice(
            name: name,
            value: price,
            date: date,
            monthly: monthly,
          ),
        );
    Navigator.of(context).pop();
  }

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
    final price = useState(0.0);
    final purpose = useState('');
    final date = useState(DateTime.now());
    final monthly = useState(false);

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
                PriceTextFieldField(
                  controller: priceController,
                  hasError: false,
                  onSubmitted: (_) {},
                ),
                const SizedBox(height: 8),
                PurposeTextFieldField(
                  controller: purposeController,
                  hasError: false,
                  onSubmitted: (_) {},
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CText('Wiederkehrende Ausgabe?'),
                    const SizedBox(
                      width: 24,
                    ),
                    Checkbox(
                      value: monthly.value,
                      side: const BorderSide(color: Colors.teal),
                      onChanged: (value) => monthly.value = value ?? false,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
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
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _onDone(
                    context,
                    price.value,
                    purpose.value,
                    date.value,
                    monthly.value,
                  ),
                  child: const CText(
                    'Hinzufügen',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const CText(
                    'Abbrechen',
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
