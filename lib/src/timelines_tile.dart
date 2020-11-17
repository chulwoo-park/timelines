import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timelines/src/timelines_event.dart';

import 'timelines_theme.dart';

/// TODO
/// style:
///   start
///   end
///   ... (cross/zigzag ?)
class TimelinesTile extends StatelessWidget {
  /// TODO
  final Widget child;

  /// TODO
  final Widget eventChild;

  /// TODO
  final Axis direction;

  /// TODO
  final double eventPosition;

  /// TODO
  final bool drawStartLine;

  /// TODO
  final bool drawEndLine;

  const TimelinesTile({
    Key key,
    @required this.child,
    this.direction,
    this.eventChild,
    this.eventPosition = 0.5,
    this.drawStartLine = true,
    this.drawEndLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelinesTheme.of(context).direction;
    switch (direction) {
      case Axis.vertical:
        return IntrinsicHeight(
          // TODO
          child: Row(
            children: [
              // TODO order
              TimelinesEvent.circle(
                indicatorChild: eventChild,
                position: eventPosition,
                drawStartLine: drawStartLine,
                drawEndLine: drawEndLine,
              ),
              child,
            ],
          ),
        );
      case Axis.horizontal:
        return IntrinsicWidth(
          child: Column(
            children: [
              // TODO order
              TimelinesEvent.circle(
                indicatorChild: eventChild,
                position: eventPosition,
                drawStartLine: drawStartLine,
                drawEndLine: drawEndLine,
              ),
              child,
            ],
          ),
        );
    }

    throw ArgumentError('TODO');
  }
}
