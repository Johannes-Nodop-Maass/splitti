import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
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
    return BlocBuilder<ReceiptsCubit, Invoices>(
      builder: (context, receipts) {
        final cubit = context.watch<ReceiptsCubit>();

        final screenWidth = MediaQuery.sizeOf(context).width;

        final textColumnWidth = (screenWidth - 24 * 9.5) / 2;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
            leading: IconButton(
              onPressed: () async {
                final confirmed = await Navigator.of(context).push(
                  QuitConfirmationRoute(),
                );

                if (confirmed ?? false) {
                  cubit.reset();
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
                  child: receipts.invoices.isNotEmpty
                      ? DataTable(
                          columnSpacing: 24,
                          headingRowHeight: 32,
                          columns: const [
                            DataColumn(label: CText('Datum')),
                            DataColumn(label: CText('Zweck')),
                            DataColumn(label: CText('Betrag')),
                            DataColumn(label: CText('')),
                            DataColumn(label: CText('')),
                          ],
                          rows: [
                            ...receipts.invoices.mapList(
                              (receipt) => _dataRow(
                                receipt,
                                textColumnWidth,
                                context,
                                cubit,
                              ),
                            ),
                          ],
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
    ReceiptsCubit cubit,
  ) {
    return DataRow(
      cells: [
        SizedBox(
          child: CText(
            DateFormat('dd.MM').format(receipt.date),
          ),
        ),
        SizedBox(
          width: textColumnWidth,
          child: CText(
              '${receipt.name} ${receipt.recurrence != Recurrence.once ? '↻' : ''}'),
        ),
        SizedBox(
          width: textColumnWidth,
          child: CText(
              '${receipt.value.toStringAsFixed(2).replaceAll('.', ',')} €'),
        ),
        SizedBox(
          width: 24,
          child: IconButton(
            onPressed: () =>
                Navigator.of(context).push(EditReceiptRoute(receipt)),
            icon: const Icon(Icons.edit),
          ),
        ),
        SizedBox(
          width: 24,
          child: IconButton(
            onPressed: () async {
              final confirmed = await Navigator.of(context).push(
                QuitConfirmationRoute(),
              );

              if (confirmed ?? false) {
                cubit.remove(receipt);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ].mapList((e) => DataCell(e)),
    );
  }
}
