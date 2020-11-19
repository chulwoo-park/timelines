import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'connectors.dart';
import 'indicators.dart';
import 'timeline_theme.dart';
import 'util.dart';

/// [TimelineTile]'s timeline node
mixin TimelineTileNode on Widget {
  /// {@template timelines.node.position}
  /// If this is null, then the [TimelineThemeData.nodePosition] is used.
  /// {@endtemplate}
  double get position;
  double getEffectivePosition(BuildContext context) {
    return position ?? TimelineTheme.of(context).nodePosition;
  }
}

/// A widget that displays indicator and two connectors.
///
/// The [indicator] displayed between the [startConnector] and [endConnector]
class TimelineNode extends StatelessWidget with TimelineTileNode {
  /// Creates a timeline node.
  ///
  /// The [indicatorPosition] must be null or a value between 0 and 1.
  const TimelineNode({
    Key key,
    this.direction,
    this.startConnector,
    this.endConnector,
    @required this.indicator,
    this.indicatorPosition,
    this.position,
  })  : assert(indicator != null),
        assert(indicatorPosition == null || 0 <= indicatorPosition && indicatorPosition <= 1),
        super(key: key);

  /// Creates a timeline node that connects the dot indicator in a solid line.
  TimelineNode.simple({
    Key key,
    Axis direction,
    Color color,
    double lineThickness,
    double indicatorPosition,
    double indicatorSize = 15.0,
    Widget indicatorChild,
    bool drawStartConnector = true,
    bool drawEndConnector = true,
  }) : this(
          key: key,
          direction: direction,
          startConnector: drawStartConnector
              ? SolidLineConnector(
                  direction: direction,
                  color: color,
                  thickness: lineThickness,
                )
              : null,
          endConnector: drawEndConnector
              ? SolidLineConnector(
                  direction: direction,
                  color: color,
                  thickness: lineThickness,
                )
              : null,
          indicator: DotIndicator(
            child: indicatorChild,
            position: indicatorPosition,
            size: indicatorSize,
            color: color,
          ),
        );

  /// {@macro timelines.direction}
  final Axis direction;

  /// The connector of the start edge of this node
  final Widget startConnector;

  /// The connector of the end edge of this node
  final Widget endConnector;

  /// The indicator of the node
  final Widget indicator;

  /// The position of a indicator between the two connectors.
  ///
  /// {@macro timelines.indicator.position}
  final double indicatorPosition;

  /// A position of timeline node between both two contents.
  ///
  /// {@macro timelines.node.position}
  @override
  final double position;

  double _getEffectiveIndicatorPosition(BuildContext context) {
    var indicatorPosition = this.indicatorPosition;
    indicatorPosition ??= (indicator is Indicator)
        ? (indicator as Indicator).getEffectivePosition(context)
        : TimelineTheme.of(context).indicatorPosition;
    return indicatorPosition;
  }

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final indicatorFlex = _getEffectiveIndicatorPosition(context) * kFlexMultiplier; // multiplication for flex
    Widget result = indicator;
    final nodeItems = [
      Flexible(
        flex: indicatorFlex.toInt(),
        child: startConnector ?? TransparentConnector(),
      ),
      indicator,
      Flexible(
        flex: (kFlexMultiplier - indicatorFlex).toInt(),
        child: endConnector ?? TransparentConnector(),
      ),
    ];
    switch (direction) {
      case Axis.vertical:
        result = Column(
          mainAxisSize: MainAxisSize.min,
          children: nodeItems,
        );
        break;
      case Axis.horizontal:
        result = Row(
          mainAxisSize: MainAxisSize.min,
          children: nodeItems,
        );
        break;
    }

    return result;
  }
}
