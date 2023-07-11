// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoices _$InvoicesFromJson(Map<String, dynamic> json) => Invoices(
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoicesToJson(Invoices instance) => <String, dynamic>{
      'invoices': instance.invoices,
    };
