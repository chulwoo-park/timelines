import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'indicators.dart';
import 'connectors.dart';

class TimelineNode extends StatelessWidget {
  /// TODO
  final Axis direction;

  /// TODO rename ? childPosition, point, childPoint, ....
  /// 0-1
  final double position;

  /// TODO
  final ConnectorStyle connectorStyle;

  /// TODO
  final bool drawStartConnector;

  /// TODO
  final bool drawEndConnector;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  const TimelineNode({
    Key key,
    this.direction,
    this.position = 0.5,
    this.connectorStyle = ConnectorStyle.solid,
    this.drawStartConnector = true,
    this.drawEndConnector = true,
    @required this.child,
  })  : assert(0 <= position && position <= 1),
        super(key: key);

  TimelineNode.circle({
    Key key,
    Axis direction,
    double position = 0.5,
    ConnectorStyle connectorStyle,
    bool drawStartConnector = true,
    bool drawEndConnector = true,
    double indicatorSize = 15.0,
    Widget indicatorChild,
  }) : this(
          key: key,
          direction: direction,
          position: position,
          connectorStyle: connectorStyle,
          drawStartConnector: drawStartConnector,
          drawEndConnector: drawEndConnector,
          child: DotIndicator(
            size: indicatorSize,
            child: indicatorChild,
          ),
        );

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    Widget result = child;

    /// TODO connector from style
    /// if (connectorStyle ... )
    final startConnector = SolidLineConnector(direction: direction);
    final endConnector = SolidLineConnector(direction: direction);

    switch (direction) {
      case Axis.vertical:
        result = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: (position * 10).toInt(),
              child: startConnector ?? TransparentConnector(),
            ),
            child,
            Flexible(
              flex: ((1 - position) * 10).toInt(),
              child: endConnector ?? TransparentConnector(),
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
              child: startConnector ?? TransparentConnector(),
            ),
            child,
            Flexible(
              flex: ((1 - position) * 10).toInt(),
              child: endConnector ?? TransparentConnector(),
            ),
          ],
        );
        break;
    }

    return result;
  }
}
