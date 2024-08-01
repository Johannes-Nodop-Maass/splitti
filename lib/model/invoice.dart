import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice extends Equatable {
  const Invoice({
    required this.value,
    required this.name,
    required this.date,
    this.recurrence = Recurrence.once,
  });

  final double value;
  final String name;
  final DateTime date;
  final Recurrence recurrence;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  @override
  List<Object> get props => [value, name, date, recurrence];
}

enum Recurrence {
  @JsonValue("Einmalig")
  once,
  @JsonValue("Monatlich")
  monthly,
  @JsonValue("Zweimonatlich")
  bimonthly,
  @JsonValue("Quartalsweise")
  quarterly,
  @JsonValue("Halbjährlich")
  semiannual,
  @JsonValue("Jährlich")
  annual,
}
