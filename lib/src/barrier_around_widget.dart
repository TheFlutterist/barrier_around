// ignore_for_file: overridden_fields

import 'dart:ui';

import 'package:flutter/material.dart';

import 'calculate_position.dart';
import 'barrier_around_layouts.dart';
import 'rrect_clipper.dart';

class BarrierAround extends StatefulWidget {
  @override
  final GlobalKey key;

  final Widget child;

  final BorderRadius? barrierBorderRadius;

  final Color barrierColor;

  final double barrierOpacity;

  final double? barrierBlur;

  final EdgeInsets targetPadding;

  final VoidCallback? onBarrierTap;

  final bool dismissOnBarrierTap;

  final bool animateBarrier;

  final Duration animationDuration;

  const BarrierAround({
    required this.key,
    required this.child,
    this.barrierBorderRadius,
    this.barrierColor = Colors.black45,
    this.barrierOpacity = 0.75,
    this.barrierBlur,
    this.targetPadding = EdgeInsets.zero,
    this.onBarrierTap,
    this.dismissOnBarrierTap = true,
    this.animateBarrier = true,
    this.animationDuration = const Duration(milliseconds: 150),
  })  : assert(barrierOpacity >= 0.0 && barrierOpacity <= 1.0,
            "barrier opacity must be between 0 and 1."),
        super(key: key);

  @override
  State<BarrierAround> createState() => BarrierAroundState();
}

class BarrierAroundState extends State<BarrierAround>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  Animation<double>? _blurAnimation;
  Animation<double>? _opacityAnimation;

  CalculatePosition? _position;
  bool _showBarrier = false;

  @override
  void initState() {
    super.initState();

    if (widget.animateBarrier) {
      _controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      if (widget.barrierBlur != null && widget.barrierBlur! > 0) {
        _blurAnimation = Tween<double>(begin: 0, end: widget.barrierBlur!)
            .animate(_controller!)
          ..addListener(() {
            setState(() {});
          });
      }

      _opacityAnimation = Tween<double>(begin: 0, end: widget.barrierOpacity)
          .animate(_controller!)
        ..addListener(() {
          setState(() {});
        });

      _controller?.forward(from: _controller?.lowerBound);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_showBarrier) {
      _position ??= CalculatePosition(
        key: widget.key,
        padding: widget.targetPadding,
        screenWidth: MediaQuery.of(context).size.width,
        screenHeight: MediaQuery.of(context).size.height,
      );

      showBarrier();
    }
  }

  void showBarrier() {
    if (!_showBarrier) {
      setState(() {
        _showBarrier = true;
      });

      if (widget.animateBarrier) {
        _controller?.forward(from: _controller?.lowerBound);
      }
    }
  }

  void dismissBarrier() {
    if (_showBarrier) {
      if (widget.animateBarrier) {
        _controller?.reverse().whenCompleteOrCancel(() {
          setState(() {
            _showBarrier = false;
          });
        });
      } else {
        setState(() {
          _showBarrier = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showBarrier) {
      return AnchoredBarrier(
        barrierBuilder: (context, rectBound, offset) {
          final size = MediaQuery.of(context).size;
          _position = CalculatePosition(
            key: widget.key,
            padding: widget.targetPadding,
            screenWidth: size.width,
            screenHeight: size.height,
          );

          return buildBarrierOnTarget(offset, rectBound.size, rectBound, size);
        },
        showBarrier: true,
        child: widget.child,
      );
    }

    return widget.child;
  }

  Widget buildBarrierOnTarget(
    Offset offset,
    Size size,
    Rect rectBound,
    Size screenSize,
  ) {
    double? blurValue = widget.barrierBlur;

    if (widget.animateBarrier && _blurAnimation != null) {
      blurValue = _blurAnimation!.value;
    }

    double opacityValue = widget.barrierOpacity;

    if (widget.animateBarrier && _opacityAnimation != null) {
      opacityValue = _opacityAnimation!.value;
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: _showBarrier
              ? () {
                  if (widget.dismissOnBarrierTap) {
                    dismissBarrier();
                  }

                  widget.onBarrierTap?.call();
                }
              : null,
          child: ClipPath(
            clipper: RRectClipper(
              area: rectBound,
              radius: widget.barrierBorderRadius,
              overlayPadding: widget.targetPadding,
            ),
            child: blurValue != null
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurValue,
                      sigmaY: blurValue,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: widget.barrierColor.withOpacity(opacityValue),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: widget.barrierColor.withOpacity(opacityValue),
                    ),
                  ),
          ),
        ),
        _TargetWidget(
          offset: offset,
          size: size,
          radius: widget.barrierBorderRadius,
        ),
      ],
    );
  }
}

class _TargetWidget extends StatelessWidget {
  final Offset offset;
  final Size? size;
  final BorderRadius? radius;

  const _TargetWidget({
    Key? key,
    required this.offset,
    this.size,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: IgnorePointer(
          ignoring: true,
          child: Container(
            height: size!.height + 16,
            width: size!.width + 16,
            decoration:
                radius != null ? BoxDecoration(borderRadius: radius) : null,
          ),
        ),
      ),
    );
  }
}
