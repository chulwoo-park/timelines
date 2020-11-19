import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'connectors.dart';

/// Paints a [DashedLineConnector].
class DashedLinePainter extends CustomPainter {
  /// Creates a dashed line painter.
  ///
  /// The [dashSize] argument must be 1 or more, and the [gapSize] and [strokeWidth] arguments must be positive numbers.
  /// The [direction], [color], [gapColor] and [strokeCap] arguments must not be null.
  const DashedLinePainter({
    @required this.direction,
    @required this.color,
    this.gapColor = Colors.transparent,
    this.dashSize = 1,
    this.gapSize = 2,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.square,
  })  : assert(direction != null),
        assert(color != null),
        assert(gapColor != null),
        assert(dashSize >= 1),
        assert(gapSize >= 0),
        assert(strokeWidth >= 0),
        assert(strokeCap != null);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color to paint dash of line.
  final Color color;

  /// The color to paint gap(another dash) of line.
  final Color gapColor;

  /// The size of dash
  final double dashSize;

  /// The size of gap, it can be displayed differently than expected depending on the [strokeWidth].
  final double gapSize;

  /// The stroke width of dash and gap.
  final double strokeWidth;

  /// Styles to use for line endings.
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    var lineSize;

    if (direction == Axis.vertical) {
      lineSize = size.height;
    } else if (direction == Axis.horizontal) {
      lineSize = size.width;
    }

    var offset = _DashOffset(
      lineSize: lineSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: direction,
    );

    while (offset.offset < lineSize) {
      // draw dash
      paint.color = color;
      canvas.drawLine(
        offset,
        offset.translateDashSize(),
        paint,
      );
      offset = offset.translateDashSize();

      // draw gap
      if (gapColor != Colors.transparent) {
        paint.color = gapColor;
        canvas.drawLine(
          offset,
          offset.translateGapSize(),
          paint,
        );
      }
      offset = offset.translateGapSize();
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return direction != oldDelegate.direction ||
        color != oldDelegate.color ||
        gapColor != oldDelegate.gapColor ||
        dashSize != oldDelegate.dashSize ||
        gapSize != oldDelegate.gapSize ||
        strokeWidth != oldDelegate.strokeWidth ||
        strokeCap != oldDelegate.strokeCap;
  }
}

class _DashOffset extends Offset {
  factory _DashOffset({
    double offset = 0.0,
    @required double lineSize,
    @required double dashSize,
    @required double gapSize,
    @required Axis axis,
  }) {
    return _DashOffset._(
      dx: axis == Axis.vertical ? 0 : offset,
      dy: axis == Axis.vertical ? offset : 0,
      lineSize: lineSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: axis,
    );
  }

  const _DashOffset._({
    double dx = 0,
    double dy = 0,
    @required this.lineSize,
    @required this.dashSize,
    @required this.gapSize,
    @required this.axis,
  }) : super(dx, dy);

  final double lineSize;
  final double dashSize;
  final double gapSize;
  final Axis axis;

  double get offset {
    if (axis == Axis.vertical) {
      return dy;
    } else {
      return dx;
    }
  }

  _DashOffset translateDashSize() {
    return _translateDirectionally(dashSize);
  }

  _DashOffset translateGapSize() {
    return _translateDirectionally(gapSize);
  }

  _DashOffset _translateDirectionally(double offset) {
    if (axis == Axis.vertical) {
      return translate(0, offset);
    } else {
      return translate(offset, 0);
    }
  }

  @override
  Offset translate(double translateX, double translateY) {
    double dx, dy;
    if (axis == Axis.vertical) {
      dx = 0;
      dy = this.dy + translateY;
    } else {
      dx = this.dx + translateX;
      dy = 0;
    }
    return _DashOffset._(
      dx: min(dx, lineSize),
      dy: min(dy, lineSize),
      lineSize: lineSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: axis,
    );
  }
}
