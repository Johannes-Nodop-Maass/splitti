import 'package:flutter/material.dart';
import 'package:splitti/widgets/bottom_sheets/cupertino_bottom_sheet_container.dart';
import 'package:splitti/widgets/bottom_sheets/modal_bottom_sheet.dart';

const double _previousPageVisibleOffset = 10;

class _DraggableBottomSheet<T> extends StatefulWidget {
  const _DraggableBottomSheet({
    super.key,
    this.closeProgressThreshold,
    required this.route,
    this.expanded = false,
  });

  final double? closeProgressThreshold;
  final WBDraggableBottomSheetRoute<T> route;
  final bool expanded;

  @override
  _DraggableBottomSheetState<T> createState() =>
      _DraggableBottomSheetState<T>();
}

class _DraggableBottomSheetState<T> extends State<_DraggableBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(widget.route._animationController != null);

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: ModalBottomSheet(
        animationCurve: widget.route.animationCurve,
        expanded: widget.route.expanded,
        containerBuilder: (_, __, child) =>
            CupertinoBottomSheetContainer(child: child),
        closeProgressThreshold: widget.closeProgressThreshold ?? 0.7,
        animationController: widget.route._animationController!,
        onClosing: () =>
            widget.route.isCurrent ? Navigator.of(context).pop() : null,
        builder: widget.route.builder,
      ),
    );
  }
}

abstract class WBDraggableBottomSheetRoute<T> extends PopupRoute<T> {
  WBDraggableBottomSheetRoute({
    required this.builder,
    this.closeProgressThreshold,
    this.semanticBarrierLabel,
    this.modalBarrierColor,
    this.expanded = true,
    this.bounce = false,
    this.shouldResizeInBackground = true,
    this.animationCurve = ModalBottomSheet.decelerateEasing,
    this.duration = ModalBottomSheet.defaultDuration,
    this.isBarrierDismissible = false,
    super.settings,
  });

  final DraggableWidgetBuilder builder;
  final double? closeProgressThreshold;
  final String? semanticBarrierLabel;
  final Color? modalBarrierColor;
  final bool expanded;
  final bool bounce;
  final bool shouldResizeInBackground;
  final Curve animationCurve;
  final Duration duration;
  final bool isBarrierDismissible;

  AnimationController? _animationController;

  @override
  Duration get transitionDuration => duration;

  @override
  bool get barrierDismissible => isBarrierDismissible;

  @override
  String? get barrierLabel => semanticBarrierLabel;

  @override
  // ignore: regexp_exclude
  Color get barrierColor => modalBarrierColor ?? Colors.black.withOpacity(0.35);

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = ModalBottomSheet.createAnimationController(
      navigator!.overlay!,
      duration: transitionDuration,
    );

    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _DraggableBottomSheet<T>(
      closeProgressThreshold: closeProgressThreshold,
      route: this,
      expanded: expanded,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final distanceWithScale = (topPadding + _previousPageVisibleOffset) * 0.9;
    final offsetY = secondaryAnimation.value * (topPadding - distanceWithScale);
    final scale = 1 - secondaryAnimation.value / 10;

    return shouldResizeInBackground
        ? AnimatedBuilder(
            builder: (context, child) => Transform.translate(
              offset: Offset(0, offsetY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
            animation: secondaryAnimation,
            child: child,
          )
        : child;
  }
}
