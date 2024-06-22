import 'package:flutter/material.dart';
import 'package:splitti/widgets/text.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const CText(
        'Abbrechen',
        fontWeight: FontWeight.w900,
        color: Colors.red,
      ),
    );
  }
}
