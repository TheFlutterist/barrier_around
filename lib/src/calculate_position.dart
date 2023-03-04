import 'package:flutter/material.dart';

class CalculatePosition {
  final GlobalKey? key;
  final EdgeInsets padding;
  final double? screenWidth;
  final double? screenHeight;

  CalculatePosition({
    this.key,
    this.padding = EdgeInsets.zero,
    this.screenWidth,
    this.screenHeight,
  });

  Rect getRect() {
    final box = key!.currentContext!.findRenderObject() as RenderBox;

    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dx.isNaN || boxOffset.dy.isNaN) {
      return const Rect.fromLTRB(0, 0, 0, 0);
    }

    final topLeft = box.size.topLeft(boxOffset);
    final bottomRight = box.size.bottomRight(boxOffset);

    final rect = Rect.fromLTRB(
      topLeft.dx - padding.left < 0 ? 0 : topLeft.dx - padding.left,
      topLeft.dy - padding.top < 0 ? 0 : topLeft.dy - padding.top,
      bottomRight.dx + padding.right > screenWidth!
          ? screenWidth!
          : bottomRight.dx + padding.right,
      bottomRight.dy + padding.bottom > screenHeight!
          ? screenHeight!
          : bottomRight.dy + padding.bottom,
    );

    return rect;
  }

  double getBottom() {
    final box = key!.currentContext!.findRenderObject() as RenderBox;
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dy.isNaN) return padding.bottom;

    final bottomRight = box.size.bottomRight(boxOffset);
    return bottomRight.dy + padding.bottom;
  }

  double getTop() {
    final box = key!.currentContext!.findRenderObject() as RenderBox;
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));

    if (boxOffset.dy.isNaN) return 0 - padding.top;
    final topLeft = box.size.topLeft(boxOffset);
    return topLeft.dy - padding.top;
  }

  double getLeft() {
    final box = key!.currentContext!.findRenderObject() as RenderBox;
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));

    if (boxOffset.dx.isNaN) return 0 - padding.left;
    final topLeft = box.size.topLeft(boxOffset);
    return topLeft.dx - padding.left;
  }

  double getRight() {
    final box = key!.currentContext!.findRenderObject() as RenderBox;
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));

    if (boxOffset.dx.isNaN) return padding.right;
    final bottomRight =
        box.size.bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));
    return bottomRight.dx + padding.right;
  }

  double getHeight() => getBottom() - getTop();

  double getWidth() => getRight() - getLeft();

  double getCenter() => (getLeft() + getRight()) / 2;
}
