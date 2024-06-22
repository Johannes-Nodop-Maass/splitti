import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitti/widgets/text_fields/input_border.dart';

class PriceTextFieldField extends StatelessWidget {
  const PriceTextFieldField({
    super.key,
    required this.hasError,
    required this.onSubmitted,
    required this.controller,
  });

  final bool hasError;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final fieldEmpty = controller.text.isEmpty;

    const errorBorderColor = Colors.red;

    return TextField(
      style: const TextStyle(color: Colors.grey),
      autocorrect: false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.|,)?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: 'Betrag',
        errorText: hasError ? '' : null,
        errorStyle: const TextStyle(height: 0),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        errorBorder: CInputBorder(
          borderSide: const BorderSide(
            color: errorBorderColor,
            width: 2,
          ),
          dividerOpacity: fieldEmpty ? 0 : 1,
        ),
        focusedErrorBorder: CInputBorder(
          borderSide: const BorderSide(
            color: errorBorderColor,
            width: 2,
          ),
          dividerOpacity: fieldEmpty ? 0 : 1,
        ),
        focusedBorder: CInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
          dividerOpacity: fieldEmpty ? 0 : 1,
        ),
        enabledBorder: CInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          dividerOpacity: fieldEmpty ? 0 : 1,
        ),
        suffixIcon: fieldEmpty
            ? null
            : IconButton(
                iconSize: 20,
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: controller.clear,
              ),
      ),
      autofillHints: const [AutofillHints.transactionAmount],
      keyboardType: Platform.isIOS
          ? const TextInputType.numberWithOptions(signed: true, decimal: true)
          : TextInputType.number,
      textInputAction: TextInputAction.next,
      onSubmitted: onSubmitted,
      controller: controller,
    );
  }
}
