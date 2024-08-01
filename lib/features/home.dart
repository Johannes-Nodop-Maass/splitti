import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:splitti/extensions/iterable.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/model/invoices.dart';
import 'package:splitti/state/receipts_cubit.dart';
import 'package:splitti/widgets/add_receipt_route.dart';
import 'package:splitti/widgets/edit_receipt_route.dart';
import 'package:splitti/widgets/quit_confirmation_route.dart';
import 'package:splitti/widgets/text.dart';

class HomePage extends HookWidget {
  const HomePage({super.key, required this.title});

  final String title;

  bool _isDue(int dueMonth, int recurrence) {
    final currentMonth = DateTime.now().month;
    return (currentMonth - dueMonth) % 2 == 0;
  }

  double _calculateTotal(Invoices receipts) =>
      (receipts.invoices.fold(0.0, (prev, receipt) {
        final recurrence = receipt.recurrence;

        switch (recurrence) {
          case Recurrence.once:
          case Recurrence.monthly:
            return prev + receipt.value;

          case Recurrence.bimonthly:
            return _isDue(receipt.date.month, 2) ? prev + receipt.value : prev;
          case Recurrence.quarterly:
            return _isDue(receipt.date.month, 3) ? prev + receipt.value : prev;
          case Recurrence.semiannual:
            return _isDue(receipt.date.month, 6) ? prev + receipt.value : prev;
          case Recurrence.annual:
            return _isDue(receipt.date.month, 12) ? prev + receipt.value : prev;
        }
      }));

  @override
  Widget build(BuildContext context) {
    final sortIndex = useState(0);
    final sortAscending = useState(true);

    useEffect(() {
      context
          .read<ReceiptsCubit>()
          .state
          .sort(sortIndex.value, sortAscending.value);
      return;
    }, [sortIndex.value, sortAscending.value]);

    return BlocBuilder<ReceiptsCubit, Invoices>(
      builder: (context, receipts) {
        void sort(int index, bool ascending) {
          sortIndex.value = index;
          sortAscending.value = ascending;
        }

        final screenWidth = MediaQuery.sizeOf(context).width;

        final textColumnWidth = (screenWidth - 16 * 13) / 2;

        final dataColumns = [
          DataColumn(onSort: sort, label: const CText('Datum')),
          DataColumn(onSort: sort, label: const CText('Zweck')),
          DataColumn(onSort: sort, label: const CText('Betrag')),
          const DataColumn(label: CText('')),
          const DataColumn(label: CText('')),
        ];

        final dataRows = [
          ...receipts.invoices.mapList(
            (receipt) => _dataRow(
              receipt,
              textColumnWidth,
              context,
            ),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
            leading: IconButton(
              onPressed: () async {
                final confirmed = await Navigator.of(context).push(
                  QuitConfirmationRoute(
                    'Möchtest du alle nicht wiederkehrenden Belege löschen?',
                  ),
                );

                if (confirmed ?? false) {
                  receipts.reset();
                }
              },
              icon: const Icon(Icons.playlist_remove),
            ),
          ),
          body: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 128),
                  child: receipts.invoices.isNotEmpty
                      ? DataTable(
                          sortColumnIndex: sortIndex.value,
                          sortAscending: sortAscending.value,
                          columnSpacing: 16,
                          headingRowHeight: 32,
                          columns: dataColumns,
                          rows: dataRows,
                        )
                      : const CText('Keine Einträge vorhanden.'),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 24,
                child: CText(
                  'Total: ${_calculateTotal(receipts).toStringAsFixed(2).replaceAll('.', ',')} €',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(AddReceiptRoute()),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  DataRow _dataRow(
    Invoice receipt,
    double textColumnWidth,
    BuildContext context,
  ) {
    final date = DateFormat('dd.MM').format(receipt.date);
    final name =
        '${receipt.name} ${receipt.recurrence != Recurrence.once ? '↻' : ''}';
    final value = '${receipt.value.toStringAsFixed(2).replaceAll('.', ',')} €';

    return DataRow(
      cells: [
        SizedBox(
          child: CText(date),
        ),
        SizedBox(
          width: textColumnWidth * 1.5 - 16,
          child: CText(name),
        ),
        SizedBox(
          width: textColumnWidth / 1.5,
          child: CText(value),
        ),
        SizedBox(
          width: 24,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () =>
                Navigator.of(context).push(EditReceiptRoute(receipt)),
            icon: const Icon(Icons.edit),
          ),
        ),
        SizedBox(
          width: 24,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final confirmed = await Navigator.of(context).push(
                QuitConfirmationRoute(
                  'Möchtest du den Eintrag "$name" vom $date über $value wirklich löschen?',
                ),
              );

              if (context.mounted && (confirmed ?? false)) {
                context.read<ReceiptsCubit>().remove(receipt);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ].mapList((e) => DataCell(e)),
    );
  }
}
