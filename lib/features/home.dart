import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:spliti/extensions/iterable.dart';
import 'package:spliti/model/invoices.dart';
import 'package:spliti/state/receipts_cubit.dart';
import 'package:spliti/widgets/add_receipt_route.dart';
import 'package:spliti/widgets/quit_confirmation_route.dart';
import 'package:spliti/widgets/text.dart';

class HomePage extends HookWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsCubit, Invoices>(
      builder: (context, receipts) {
        final cubit = context.watch<ReceiptsCubit>();

        final screenWidth = MediaQuery.sizeOf(context).width;

        final textColumnWidth = (screenWidth - 24 * 8) / 2;

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
                          ],
                          rows: [
                            ...receipts.invoices.mapList(
                              (receipt) => DataRow(
                                cells: [
                                  SizedBox(
                                    child: CText(
                                      DateFormat('dd.MM').format(receipt.date),
                                    ),
                                  ),
                                  SizedBox(
                                    width: textColumnWidth,
                                    child: CText(
                                        '${receipt.name} ${receipt.monthly ? '↻' : ''}'),
                                  ),
                                  SizedBox(
                                    width: textColumnWidth,
                                    child: CText(
                                        '${receipt.value.toStringAsFixed(2).replaceAll('.', ',')} €'),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: IconButton(
                                      onPressed: () => cubit.remove(receipt),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  )
                                ].mapList((e) => DataCell(e)),
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
                  'Total: ${(receipts.invoices.fold(0.0, (prev, receipt) => prev + receipt.value)).toStringAsFixed(2).replaceAll('.', ',')} €',
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
}
