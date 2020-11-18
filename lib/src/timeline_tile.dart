import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timeline_node.dart';
import 'timeline_theme.dart';

/// TODO
/// style:
///   start
///   end
///   ... (cross/zigzag ?)
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    Key key,
    @required this.child,
    this.direction,
    this.indicatorChild,
    this.indicatorPosition,
    this.drawStartLine = true,
    this.drawEndLine = true,
  }) : super(key: key);

  /// TODO
  final Widget child;

  /// TODO
  final Widget indicatorChild;

  /// TODO
  final Axis direction;

  /// TODO
  final double indicatorPosition;

  /// TODO
  final bool drawStartLine;

  /// TODO
  final bool drawEndLine;

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    switch (direction) {
      case Axis.vertical:
        return IntrinsicHeight(
          // TODO
          child: Row(
            children: [
              // TODO order
              TimelineNode.simple(indicatorPosition: indicatorPosition),
              child,
            ],
          ),
        );
      case Axis.horizontal:
        return IntrinsicWidth(
          child: Column(
            children: [
              // TODO order
              TimelineNode.simple(indicatorPosition: indicatorPosition),
              child,
            ],
          ),
        );
    }

    throw ArgumentError('TODO');
  }
}
