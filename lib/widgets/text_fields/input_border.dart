import 'dart:ui';

import 'package:flutter/material.dart';

/// An input border with a vertical line on the right.
class CInputBorder extends OutlineInputBorder {
  const CInputBorder({
    super.borderSide,
    super.borderRadius,
    super.gapPadding,
    this.dividerOpacity = 1.0,
  });

  final double dividerOpacity;

  @override
  CInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    double? dividerOpacity,
  }) {
    return CInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      dividerOpacity: dividerOpacity ?? this.dividerOpacity,
    );
  }

  @override
  CInputBorder scale(double t) {
    return CInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      gapPadding: gapPadding * t,
      dividerOpacity: dividerOpacity * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CInputBorder) {
      final outline = a;

      return CInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        gapPadding: outline.gapPadding,
        dividerOpacity:
            lerpDouble(outline.dividerOpacity, dividerOpacity, t) ?? 0,
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CInputBorder) {
      final outline = b;

      return CInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        gapPadding: outline.gapPadding,
        dividerOpacity:
            lerpDouble(outline.dividerOpacity, dividerOpacity, t) ?? 0,
      );
    }

    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    super.paint(
      canvas,
      rect,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );

    final dx = textDirection == TextDirection.ltr ? rect.width - 48 : 48.0;

    canvas.drawLine(
      Offset(dx, 0),
      Offset(dx, rect.height),
      Paint()
        ..strokeWidth = borderSide.width
        ..color = borderSide.color.withValues(alpha: dividerOpacity),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.gapPadding == gapPadding &&
        other.dividerOpacity == dividerOpacity;
  }

  @override
  int get hashCode => Object.hash(
        borderSide,
        borderRadius,
        gapPadding,
        dividerOpacity,
      );
}
