import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'timelines_indicators.dart';
import 'timelines_line.dart';

class TimelinesEvent extends StatelessWidget {
  /// TODO
  final Axis direction;

  /// TODO rename ? childPosition, point, childPoint, ....
  /// 0-1
  final double position;

  /// TODO
  final TimelinesLineStyle lineStyle;

  /// TODO
  final bool drawStartLine;

  /// TODO
  final bool drawEndLine;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  const TimelinesEvent({
    Key key,
    this.direction,
    this.position = 0.5,
    this.lineStyle = TimelinesLineStyle.solid,
    this.drawStartLine = true,
    this.drawEndLine = true,
    @required this.child,
  })  : assert(0 <= position && position <= 1),
        super(key: key);

  TimelinesEvent.circle({
    Key key,
    Axis direction,
    double position = 0.5,
    TimelinesLineStyle lineStyle,
    bool drawStartLine = true,
    bool drawEndLine = true,
    double indicatorSize = 15.0,
    Widget indicatorChild,
  }) : this(
          key: key,
          direction: direction,
          position: position,
          lineStyle: lineStyle,
          drawStartLine: drawStartLine,
          drawEndLine: drawEndLine,
          child: CircleIndicator(
            size: indicatorSize,
            child: indicatorChild,
          ),
        );

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelinesTheme.of(context).direction;
    Widget result = child;

    /// TODO line from style
    /// if (lineStyle ... )
    final startLine = SolidLine(direction: direction);
    final endLine = SolidLine(direction: direction);

    switch (direction) {
      case Axis.vertical:
        result = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: (position * 10).toInt(),
              child: startLine ?? TransparentLine(),
            ),
            child,
            Flexible(
              flex: ((1 - position) * 10).toInt(),
              child: endLine ?? TransparentLine(),
            ),
          ],
        );
        break;
      case Axis.horizontal:
        result = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: (position * 10).toInt(),
              child: startLine ?? TransparentLine(),
            ),
            child,
            Flexible(
              flex: ((1 - position) * 10).toInt(),
              child: endLine ?? TransparentLine(),
            ),
          ],
        );
        break;
    }

    return result;
  }
}

class TransparentLine extends StatelessWidget {
  const TransparentLine();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
