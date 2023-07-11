import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  const Invoice({
    required this.value,
    required this.name,
    required this.date,
    this.monthly = false,
  });

  final double value;
  final String name;
  final DateTime date;
  final bool monthly;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
