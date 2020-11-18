import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'connectors.dart';
import 'indicator_theme.dart';
import 'indicators.dart';
import 'timeline_theme.dart';

/// A widget that displays indicator and two connectors.
///
/// The [indicator] displayed between the [startConnector] and [endConnector]
class TimelineNode extends StatelessWidget {
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

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis direction;

  /// The connector of the start edge of this node
  final Widget startConnector;

  /// The connector of the end edge of this node
  final Widget endConnector;

  /// The indicator of the node
  final Widget indicator;

  /// A position of indicator inside both two connectors.
  ///
  /// If this is null, then the [Indicator.position] is used. If that is also null, then this defaults to
  /// [IndicatorThemeData.position]
  ///
  /// If no [Indicator.position] and no [IndicatorThemeData] is specified, position will default to 0.5.
  final double indicatorPosition;

  double _getEffectiveIndicatorPosition(BuildContext context) {
    var indicatorPosition = this.indicatorPosition;
    indicatorPosition ??= (indicator is Indicator) ? (indicator as Indicator).getEffectivePosition(context) : 0.5;
    return indicatorPosition;
  }

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final indicatorPosition = _getEffectiveIndicatorPosition(context);
    Widget result = indicator;
    final nodeItems = [
      Flexible(
        flex: (indicatorPosition * 1000).toInt(),
        child: startConnector ?? TransparentConnector(),
      ),
      indicator,
      Flexible(
        flex: ((1 - indicatorPosition) * 1000).toInt(),
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
