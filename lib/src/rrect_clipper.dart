import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RRectClipper extends CustomClipper<ui.Path> {
  final BorderRadius? radius;
  final EdgeInsets overlayPadding;
  final Rect area;

  RRectClipper({
    this.radius,
    this.overlayPadding = EdgeInsets.zero,
    this.area = Rect.zero,
  });

  @override
  ui.Path getClip(ui.Size size) {
    const customRadius = Radius.circular(3.0);

    final rect = Rect.fromLTRB(
      area.left - overlayPadding.left,
      area.top - overlayPadding.top,
      area.right + overlayPadding.right,
      area.bottom + overlayPadding.bottom,
    );

    return Path()
      ..fillType = ui.PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: (radius?.topLeft ?? customRadius),
          topRight: (radius?.topRight ?? customRadius),
          bottomLeft: (radius?.bottomLeft ?? customRadius),
          bottomRight: (radius?.bottomRight ?? customRadius),
        ),
      );
  }

  @override
  bool shouldReclip(covariant RRectClipper oldClipper) =>
      radius != oldClipper.radius ||
      overlayPadding != oldClipper.overlayPadding ||
      area != oldClipper.area;
}
