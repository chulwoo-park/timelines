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
    double nodePosition,
    double indicatorPosition,
    double indicatorSize,
    double indicatorIndent,
    double indicatorEndIndent,
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
                  indent: indicatorIndent,
                  endIndent: indicatorEndIndent,
                )
              : null,
          endConnector: drawEndConnector
              ? SolidLineConnector(
                  direction: direction,
                  color: color,
                  thickness: lineThickness,
                  indent: indicatorIndent,
                  endIndent: indicatorEndIndent,
                )
              : null,
          indicator: DotIndicator(
            child: indicatorChild,
            position: indicatorPosition,
            size: indicatorSize,
            color: color,
          ),
          indicatorPosition: indicatorPosition,
          position: nodePosition,
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
    // TODO: support both flex and logical pixel
    final indicatorFlex = _getEffectiveIndicatorPosition(context);
    Widget positionedIndicator = indicator;
    Widget line = indicator;
    final lineItems = [
      if (indicatorFlex > 0)
        Flexible(
          flex: (indicatorFlex * kFlexMultiplier).toInt(),
          child: startConnector ?? TransparentConnector(),
        ),
      if (indicatorFlex < 1)
        Flexible(
          flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
          child: endConnector ?? TransparentConnector(),
        ),
    ];
    final positionedIndicatorItems = [
      if (indicatorFlex > 0)
        Flexible(
          flex: (indicatorFlex * kFlexMultiplier).toInt(),
          child: TransparentConnector(),
        ),
      indicator,
      Flexible(
        flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
        child: TransparentConnector(),
      ),
    ];
    switch (direction) {
      case Axis.vertical:
        line = Column(
          mainAxisSize: MainAxisSize.min,
          children: lineItems,
        );
        positionedIndicator = Column(
          mainAxisSize: MainAxisSize.min,
          children: positionedIndicatorItems,
        );
        break;
      case Axis.horizontal:
        positionedIndicator = Row(
          mainAxisSize: MainAxisSize.min,
          children: positionedIndicatorItems,
        );
        break;
    }

    Widget result = Stack(
      alignment: Alignment.center,
      children: [
        line,
        positionedIndicator,
      ],
    );

    if (TimelineTheme.of(context).direction != direction) {
      result = TimelineTheme(
        data: TimelineTheme.of(context).copyWith(
          direction: direction,
        ),
        child: result,
      );
    }

    return result;
  }
}
