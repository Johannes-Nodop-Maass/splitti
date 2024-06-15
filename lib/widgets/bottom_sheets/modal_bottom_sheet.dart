import 'package:flutter/material.dart';
import 'package:splitti/widgets/bottom_sheets/bottom_sheet_suspended_curve.dart';

const double _minFlingVelocity = 500;
const double _closeProgressThreshold = 0.5;
const double _willPopThreshold = 0.5;

typedef WidgetWithChildBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

typedef DragUpdateHandler = void Function(double primaryDelta);
typedef DragEndHandler = void Function(double velocity);

typedef DraggableWidgetBuilder = Widget Function(
  BuildContext context,
  DragUpdateHandler onDragUpdate,
  DragEndHandler onDragEnd,
);

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({
    super.key,
    required this.builder,
    this.containerBuilder,
    this.closeProgressThreshold = _closeProgressThreshold,
    this.willPopThreshold = _willPopThreshold,
    required this.animationController,
    this.animationCurve = decelerateEasing,
    this.shouldClose,
    required this.expanded,
    required this.onClosing,
  });

  final DraggableWidgetBuilder builder;

  final WidgetWithChildBuilder? containerBuilder;

  /// Specifies when the bottom sheet will be dismissed when user drags it.
  final double closeProgressThreshold;

  /// Specifies when the [shouldClose] will be called.
  final double willPopThreshold;

  /// AnimationController for show and hide animations.
  final AnimationController animationController;
  final Curve animationCurve;

  /// Forces the widget returned by [builder] to fill the viewport.
  ///
  /// If false, widget returned by [builder] will take only the space it needs.
  final bool expanded;

  /// Called when the bottom sheet begins to close.
  ///
  /// A bottom sheet might be prevented from closing (e.g. by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final void Function() onClosing;

  /// Called when the bottom sheets exceeds
  ///
  /// If returns true, the bottom sheet closes. If returns false, close is
  /// canceled and the bottom sheet goes to its previous position.
  ///
  /// Can be null, and in such case it's ignored.
  final ValueGetter<bool>? shouldClose;

  @override
  // ignore: library_private_types_in_public_api
  _ModalBottomSheetState createState() => _ModalBottomSheetState();

  /// Creates an [AnimationController] suitable for a
  /// [ModalBottomSheet.animationController].
  ///
  /// This API available as a convenience for a Material compliant bottom sheet
  /// animation. If alternative animation durations are required, a different
  /// animation controller could be provided.
  static AnimationController createAnimationController(
    TickerProvider vsync, {
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? defaultDuration,
      debugLabel: 'BottomSheet',
      vsync: vsync,
    );
  }

  static const decelerateEasing = Cubic(0, 0, 0.2, 1);
  static const defaultDuration = Duration(milliseconds: 400);
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  late AnimationController _bounceDragController;

  double? get _childHeight {
    final childContext = _childKey.currentContext;
    final renderBox = childContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.size.height;
    } else {
      return null;
    }
  }

  bool get _dismissUnderway =>
      widget.animationController.status == AnimationStatus.reverse;

  // Detect if user is dragging.
  // Used on NotificationListener to detect if ScrollNotifications are
  // before or after the user stop dragging
  bool isDragging = false;

  Curve animationCurve = Curves.linear;

  bool get hasReachedWillPopThreshold =>
      widget.animationController.value < widget.willPopThreshold;

  bool get hasReachedCloseThreshold =>
      widget.animationController.value < widget.closeProgressThreshold;

  void _close() {
    isDragging = false;
    widget.onClosing();
  }

  void _cancelClose() {
    widget.animationController.forward();

    if (!widget.animationController.isCompleted) {
      widget.animationController.value = 1;
    }

    _bounceDragController.reverse();
  }

  bool shouldClose() {
    if (widget.shouldClose == null) {
      return false;
    }

    return widget.shouldClose!();
  }

  void _handleDragUpdate(double primaryDelta) {
    animationCurve = Curves.linear;

    if (_dismissUnderway) {
      return;
    }
    isDragging = true;

    final progress = primaryDelta / (_childHeight ?? primaryDelta);

    if (widget.shouldClose != null && hasReachedWillPopThreshold) {
      _cancelClose();
      final canClose = shouldClose();
      if (canClose) {
        _close();

        return;
      } else {
        _cancelClose();
      }
    }

    widget.animationController.value -= progress;
  }

  void _handleDragEnd(double velocity) {
    animationCurve = BottomSheetSuspendedCurve(
      widget.animationController.value,
      curve: _defaultCurve,
    );

    if (_dismissUnderway || !isDragging) {
      return;
    }
    isDragging = false;
    _bounceDragController.reverse();

    var canClose = true;
    if (widget.shouldClose != null && hasReachedWillPopThreshold) {
      _cancelClose();
      canClose = shouldClose();
    }
    if (canClose) {
      // If speed is bigger than _minFlingVelocity try to close it
      if (velocity > _minFlingVelocity) {
        _close();
      } else if (hasReachedCloseThreshold) {
        if (widget.animationController.value > 0.0) {
          widget.animationController.fling(velocity: -1);
        }
        _close();
      } else {
        _cancelClose();
      }
    } else {
      _cancelClose();
    }
  }

  Curve get _defaultCurve => widget.animationCurve;

  @override
  void initState() {
    animationCurve = _defaultCurve;
    _bounceDragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bounceAnimation = CurvedAnimation(
      parent: _bounceDragController,
      curve: Curves.easeOutSine,
    );

    var child = widget.builder(context, _handleDragUpdate, _handleDragEnd);
    if (widget.containerBuilder != null) {
      child = widget.containerBuilder!(
        context,
        widget.animationController,
        child,
      );
    }

    child = AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        assert(child != null);
        final animationValue = animationCurve.transform(
          MediaQuery.accessibleNavigationOf(context)
              ? 1.0
              : widget.animationController.value,
        );

        final draggableChild = KeyedSubtree(
          key: _childKey,
          child: AnimatedBuilder(
            animation: bounceAnimation,
            builder: (context, _) => CustomSingleChildLayout(
              delegate: _CustomBottomSheetLayout(bounceAnimation.value),
              child: child,
            ),
          ),
        );

        return ClipRect(
          child: CustomSingleChildLayout(
            delegate: _ModalBottomSheetLayout(
              progress: animationValue,
              expand: widget.expanded,
            ),
            child: draggableChild,
          ),
        );
      },
      child: RepaintBoundary(child: child),
    );

    return child;
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout({required this.progress, required this.expand});

  final double progress;
  final bool expand;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: expand ? constraints.maxHeight : 0,
      maxHeight: expand ? constraints.maxHeight : constraints.minHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _CustomBottomSheetLayout extends SingleChildLayoutDelegate {
  _CustomBottomSheetLayout(this.progress);

  final double progress;
  double? childHeight;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    childHeight ??= childSize.height;

    return Offset(0, size.height - childSize.height);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight + progress * 8,
    );
  }

  @override
  bool shouldRelayout(_CustomBottomSheetLayout oldDelegate) {
    final madeProgress = progress != oldDelegate.progress;
    if (madeProgress) {
      childHeight = oldDelegate.childHeight;
    }

    return madeProgress;
  }
}
