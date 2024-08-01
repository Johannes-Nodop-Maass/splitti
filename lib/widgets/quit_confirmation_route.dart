import 'package:flutter/material.dart';
import 'package:splitti/widgets/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:splitti/widgets/text.dart';

class QuitConfirmationRoute extends WBDraggableBottomSheetRoute<bool> {
  QuitConfirmationRoute(String question)
      : super(
          builder: (_, __, ___) => QuitConfirmationScreen(question),
          expanded: false,
        );
}

class QuitConfirmationScreen extends StatelessWidget {
  const QuitConfirmationScreen(this.question, {super.key});

  final String question;

  void _onQuitCanceled(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  void _onQuitConfirmed(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                CText(
                  question,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _onQuitConfirmed(context),
                  child: const CText(
                    'Ja',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _onQuitCanceled(context),
                  child: const CText(
                    'Nein',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
