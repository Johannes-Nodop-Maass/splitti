import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  const CText(
    this.data, {
    super.key,
    this.color,
    this.style,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  final String data;
  final Color? color;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? DefaultTextStyle.of(context).style;

    return Text(
      maxLines == 1 ? data.replaceAll(' ', '\u00A0') : data,
      textAlign: textAlign,
      style: style.copyWith(color: color, fontWeight: fontWeight),
      maxLines: maxLines,
    );
  }
}
