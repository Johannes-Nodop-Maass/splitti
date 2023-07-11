import 'package:json_annotation/json_annotation.dart';
import 'package:spliti/model/invoice.dart';

part 'invoices.g.dart';

@JsonSerializable()
class Invoices {
  Invoices({
    required this.invoices,
  });

  List<Invoice> invoices;

  void add(Invoice invoice) {
    invoices.add(invoice);
  }

  void remove(Invoice invoice) {
    invoices.remove(invoice);
  }

  void reset() {
    invoices.removeWhere((receipt) => !receipt.monthly);
  }

  factory Invoices.fromJson(Map<String, dynamic> json) =>
      _$InvoicesFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesToJson(this);
}
