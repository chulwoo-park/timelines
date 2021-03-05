import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'connectors.dart';

/// Paints a [DashedLineConnector].
///
/// Draw the line like this:
/// ```
///  0 > [dash][gap][dash][gap] < constraints size
/// ```
///
/// [dashSize] specifies the size of [dash]. and [gapSize] specifies the size of
/// [gap].
///
/// When using the default colors, this painter draws a dotted line or dashed
/// line that familiar.
/// If set other [gapColor], this painter draws a line that alternates between
/// two colors.
class DashedLinePainter extends CustomPainter {
  /// Creates a dashed line painter.
  ///
  /// The [dashSize] argument must be 1 or more, and the [gapSize] and
  /// [strokeWidth] arguments must be positive numbers.
  ///
  /// The [direction], [color], [gapColor] and [strokeCap] arguments must not be
  /// null.
  const DashedLinePainter({
    required this.direction,
    required this.color,
    this.gapColor = Colors.transparent,
    this.dashSize = 1.0,
    this.gapSize = 1.0,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.square,
  })  : assert(dashSize >= 1),
        assert(gapSize >= 0),
        assert(strokeWidth >= 0);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color to paint dash of line.
  final Color color;

  /// The color to paint gap(another dash) of line.
  final Color gapColor;

  /// The size of dash
  final double dashSize;

  /// The size of gap, it also draws [gapColor]
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
      strokeWidth: strokeWidth,
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
    required Size containerSize,
    required double strokeWidth,
    required double dashSize,
    required double gapSize,
    required Axis axis,
  }) {
    return _DashOffset._(
      dx: axis == Axis.vertical ? containerSize.width / 2 : 0,
      dy: axis == Axis.vertical ? 0 : containerSize.height / 2,
      strokeWidth: strokeWidth,
      containerSize: containerSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: axis,
    );
  }

  const _DashOffset._({
    required double dx,
    required double dy,
    required this.strokeWidth,
    required this.containerSize,
    required this.dashSize,
    required this.gapSize,
    required this.axis,
  }) : super(dx, dy);

  final Size containerSize;
  final double strokeWidth;
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
    return _translateDirectionally(gapSize + strokeWidth);
  }

  _DashOffset _translateDirectionally(double offset) {
    if (axis == Axis.vertical) {
      return translate(0, offset) as _DashOffset;
    } else {
      return translate(offset, 0) as _DashOffset;
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
    double? dx,
    double? dy,
    Size? containerSize,
    double? strokeWidth,
    double? dashSize,
    double? gapSize,
    Axis? axis,
  }) {
    return _DashOffset._(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      containerSize: containerSize ?? this.containerSize,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashSize: dashSize ?? this.dashSize,
      gapSize: gapSize ?? this.gapSize,
      axis: axis ?? this.axis,
    );
  }
}
