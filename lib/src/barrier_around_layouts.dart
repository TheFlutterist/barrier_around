import 'package:flutter/material.dart';

typedef BarrierBuilderCallback = Widget Function(
    BuildContext, Rect anchorBounds, Offset anchor);

class AnchoredBarrier extends StatelessWidget {
  final bool showBarrier;
  final BarrierBuilderCallback? barrierBuilder;
  final Widget? child;

  const AnchoredBarrier({
    Key? key,
    this.showBarrier = false,
    this.barrierBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BarrierBuilder(
          showBarrier: showBarrier,
          barrierBuilder: (barrierContext) {
            final box = context.findRenderObject() as RenderBox;
            final topLeft =
                box.size.topLeft(box.localToGlobal(const Offset(0.0, 0.0)));
            final bottomRight =
                box.size.bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));

            Rect anchorBounds;
            anchorBounds = (topLeft.dx.isNaN ||
                    topLeft.dy.isNaN ||
                    bottomRight.dx.isNaN ||
                    bottomRight.dy.isNaN)
                ? const Rect.fromLTRB(0.0, 0.0, 0.0, 0.0)
                : Rect.fromLTRB(
                    topLeft.dx,
                    topLeft.dy,
                    bottomRight.dx,
                    bottomRight.dy,
                  );

            final anchorCenter = box.size.center(topLeft);
            return barrierBuilder!(barrierContext, anchorBounds, anchorCenter);
          },
          child: child,
        );
      },
    );
  }
}

class BarrierBuilder extends StatefulWidget {
  final bool showBarrier;
  final WidgetBuilder? barrierBuilder;
  final Widget? child;

  const BarrierBuilder({
    Key? key,
    this.showBarrier = false,
    this.barrierBuilder,
    this.child,
  }) : super(key: key);

  @override
  State<BarrierBuilder> createState() => _BarrierBuilderState();
}

class _BarrierBuilderState extends State<BarrierBuilder> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showBarrier) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(BarrierBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => _overlayEntry != null;

  void showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: widget.barrierBuilder!,
      );

      addToOverlay(_overlayEntry!);
    } else {
      buildOverlay();
    }
  }

  void addToOverlay(OverlayEntry overlayEntry) async {
    if (mounted) {
      if (Overlay.maybeOf(context) != null) {
        Overlay.of(context).insert(overlayEntry);
      }
    }
  }

  void hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showBarrier) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showBarrier) {
      showOverlay();
    }
  }

  void buildOverlay() async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _overlayEntry?.markNeedsBuild());
  }

  @override
  Widget build(BuildContext context) {
    buildOverlay();

    return widget.child!;
  }
}
