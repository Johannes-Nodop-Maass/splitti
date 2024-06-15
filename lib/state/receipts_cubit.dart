import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:splitti/model/invoice.dart';
import 'package:splitti/model/invoices.dart';

class ReceiptsCubit extends HydratedCubit<Invoices> {
  ReceiptsCubit() : super(Invoices(invoices: []));

  void add(Invoice receipt) {
    state.add(receipt);
    refreshState();
  }

  void remove(Invoice receipt) {
    state.remove(receipt);
    refreshState();
  }

  void reset() {
    state.reset();
    final newState = Invoices(invoices: []);
    for (var receipt in state.invoices) {
      newState.invoices.add(
        Invoice(
          value: receipt.value,
          name: receipt.name,
          date: DateTime.now(),
          monthly: receipt.monthly,
        ),
      );
    }
    emit(newState);
    refreshState();
  }

  void refreshState() => emit(_stateCopy());

  Invoices _stateCopy() => Invoices(invoices: state.invoices);

  @override
  Invoices fromJson(Map<String, dynamic> json) =>
      Invoices.fromJson(json['receipts']);

  @override
  Map<String, dynamic>? toJson(Invoices state) => {'receipts': state.toJson()};
}
