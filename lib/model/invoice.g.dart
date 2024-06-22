// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      value: (json['value'] as num).toDouble(),
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      recurrence:
          $enumDecodeNullable(_$RecurrenceEnumMap, json['recurrence']) ??
              Recurrence.once,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'value': instance.value,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'recurrence': _$RecurrenceEnumMap[instance.recurrence]!,
    };

const _$RecurrenceEnumMap = {
  Recurrence.once: 'once',
  Recurrence.monthly: 'monthly',
  Recurrence.bimonthly: 'bimonthly',
  Recurrence.quarterly: 'quarterly',
  Recurrence.semiannual: 'semiannual',
  Recurrence.annual: 'annual',
};
