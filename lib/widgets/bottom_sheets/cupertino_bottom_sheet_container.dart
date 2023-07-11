import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kPreviousPageVisibleOffset = 10;
const Radius _kDefaultTopRadius = Radius.circular(12);
const BoxShadow _kDefaultBoxShadow = BoxShadow(
  blurRadius: 10,
  // ignore: regexp_exclude
  color: Colors.black12,
  spreadRadius: 5,
);

/// Clips the child widget to rectangle with top rounded corners and adds top
/// padding (+ SafeArea padding). This padding [_kPreviousPageVisibleOffset] is
/// the height that will be displayed from previous route.
class CupertinoBottomSheetContainer extends StatelessWidget {
  const CupertinoBottomSheetContainer({
    super.key,
    this.backgroundColor,
    this.topRadius = _kDefaultTopRadius,
    this.shadow,
    required this.child,
  });

  final Color? backgroundColor;
  final Radius topRadius;
  final BoxShadow? shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.paddingOf(context).top;
    final topPadding = _kPreviousPageVisibleOffset + topSafeAreaPadding;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: topRadius),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                CupertinoTheme.of(context).scaffoldBackgroundColor,
            boxShadow: [shadow ?? _kDefaultBoxShadow],
          ),
          width: double.infinity,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ),
    );
  }
}
