import 'package:json_annotation/json_annotation.dart';
import 'package:splitti/model/invoice.dart';

part 'invoices.g.dart';

@JsonSerializable()
class Invoices {
  Invoices({required this.invoices});

  List<Invoice> invoices;

  void add(Invoice invoice) => invoices.add(invoice);

  void remove(Invoice invoice) => invoices.remove(invoice);

  void reset() => invoices.removeWhere(
        (receipt) => receipt.recurrence == Recurrence.once,
      );

  void edit(Invoice prev, Invoice edited) {
    final index = invoices.indexWhere((e) => e == prev);
    invoices[index] = edited;
  }

  void sort(int index, bool ascending) {
    invoices.sort((a, b) {
      if (index == 0) {
        return ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
      }
      if (index == 1) {
        return ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name);
      }
      return ascending
          ? a.value.compareTo(b.value)
          : b.value.compareTo(a.value);
    });
  }

  factory Invoices.fromJson(Map<String, dynamic> json) =>
      _$InvoicesFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesToJson(this);
}
