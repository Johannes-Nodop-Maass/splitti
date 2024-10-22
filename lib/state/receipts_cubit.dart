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

  void edit(Invoice prev, Invoice edited) {
    state.edit(prev, edited);
    refreshState();
  }

  void reset() {
    state.reset();
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
