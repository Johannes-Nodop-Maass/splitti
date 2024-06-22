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
        (receipt) => receipt.recurrence != Recurrence.once,
      );

  void edit(Invoice prev, Invoice edited) {
    final index = invoices.indexWhere((e) => e == prev);
    invoices[index] = edited;
  }

  factory Invoices.fromJson(Map<String, dynamic> json) =>
      _$InvoicesFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesToJson(this);
}
