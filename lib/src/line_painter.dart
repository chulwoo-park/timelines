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

    var offset = _DashOffset(
      containerSize: size,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: direction,
    );

    while (offset.hasNext) {
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
    @required Size containerSize,
    @required double dashSize,
    @required double gapSize,
    @required Axis axis,
  }) {
    return _DashOffset._(
      dx: axis == Axis.vertical ? containerSize.width / 2 : 0,
      dy: axis == Axis.vertical ? 0 : containerSize.height / 2,
      containerSize: containerSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: axis,
    );
  }

  const _DashOffset._({
    @required double dx,
    @required double dy,
    @required this.containerSize,
    @required this.dashSize,
    @required this.gapSize,
    @required this.axis,
  }) : super(dx, dy);

  final Size containerSize;
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

  bool get hasNext {
    if (axis == Axis.vertical) {
      return offset < containerSize.height;
    } else {
      return offset < containerSize.width;
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
      dx = this.dx;
      dy = this.dy + translateY;
    } else {
      dx = this.dx + translateX;
      dy = this.dy;
    }
    return copyWith(
      dx: min(dx, containerSize.width),
      dy: min(dy, containerSize.height),
    );
  }

  _DashOffset copyWith({
    double dx,
    double dy,
    Size containerSize,
    double dashSize,
    double gapSize,
    Axis axis,
  }) {
    return _DashOffset._(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      containerSize: containerSize ?? this.containerSize,
      dashSize: dashSize ?? this.dashSize,
      gapSize: gapSize ?? this.gapSize,
      axis: axis ?? this.axis,
    );
  }
}
