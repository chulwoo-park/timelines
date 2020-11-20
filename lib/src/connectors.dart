import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'connector_theme.dart';
import 'line_painter.dart';
import 'timeline.dart';
import 'timeline_node.dart';
import 'timeline_theme.dart';

enum ConnectorStyle {
  solid,
  transparent,
}

/// A thin line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class SolidLineConnector extends StatelessWidget with ThemedConnectorComponent {
  /// Creates a solid line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or non-negative.
  const SolidLineConnector({
    Key key,
    this.direction,
    this.thickness,
    this.space,
    this.indent,
    this.endIndent,
    this.color,
  })  : assert(thickness == null || thickness >= 0.0),
        assert(space == null || space >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0),
        super(key: key);

  /// {@template timelines.direction}
  /// The axis along which the timeline scrolls.
  ///
  /// If this is null, then the [TimelineThemeData.direction] is used.
  /// {@endtemplate}
  @override
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the size specified by this value.
  ///
  /// If this is null, then the [DividerThemeData.space] is used. If that is also null, then this defaults to
  /// double.infinity.
  @override
  final double space;

  /// The thickness of the line drawn within the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.thickness] is used which defaults to 2.0.
  @override
  final double thickness;

  /// The amount of empty space to the leading edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.indent] is used. If that is also null, then this defaults to 0.0.
  @override
  final double indent;

  /// The amount of empty space to the trailing edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.endIndent] is used. If that is also null, then this defaults to 0.0.
  @override
  final double endIndent;

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [ConnectorThemeData.color] is used. If that is also null, then [TimelineThemeData.color]
  /// is used.
  @override
  final Color color;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final color = getEffectiveColor(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);

    switch (direction) {
      case Axis.vertical:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            width: thickness,
            color: color,
          ),
        );
      case Axis.horizontal:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            height: thickness,
            color: color,
          ),
        );
    }

    throw ArgumentError('invalid direction: $direction');
  }
}

/// A thin dashed line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class DashedLineConnector extends StatelessWidget with ThemedConnectorComponent {
  /// Creates a dashed line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or non-negative.
  const DashedLineConnector({
    Key key,
    this.direction,
    this.thickness,
    this.dash,
    this.gap,
    this.space,
    this.indent,
    this.endIndent,
    this.color,
    this.gapColor,
  })  : assert(thickness == null || thickness >= 0.0),
        assert(space == null || space >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0),
        super(key: key);

  /// {@macro timelines.direction}
  @override
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the size specified by this value.
  ///
  /// If this is null, then the [DividerThemeData.space] is used. If that is also null, then this defaults to
  /// double.infinity.
  @override
  final double space;

  /// The thickness of the line drawn within the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.thickness] is used which defaults to 2.0.
  @override
  final double thickness;

  /// The dash size of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 2.0.
  final double dash;

  /// The gap of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 3.0.
  final double gap;

  /// The amount of empty space to the leading edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.indent] is used. If that is also null, then this defaults to 0.0.
  @override
  final double indent;

  /// The amount of empty space to the trailing edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.endIndent] is used. If that is also null, then this defaults to 0.0.
  @override
  final double endIndent;

  /// The color to use when painting the dash in the line.
  ///
  /// If this is null, then the [ConnectorThemeData.color] is used. If that is also null, then [TimelineThemeData.color]
  /// is used.
  @override
  final Color color;

  /// The color to use when painting the gap in the line.
  ///
  /// If this is null, then the [Colors.transparent] is used.
  final Color gapColor;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    return _ConnectorIndent(
      direction: direction,
      indent: getEffectiveIndent(context),
      endIndent: getEffectiveEndIndent(context),
      space: getEffectiveSpace(context),
      child: CustomPaint(
        painter: DashedLinePainter(
          direction: direction,
          color: getEffectiveColor(context),
          strokeWidth: getEffectiveThickness(context),
          dashSize: dash ?? 2.0,
          gapSize: gap ?? 3.0,
          gapColor: gapColor ?? Colors.transparent,
        ),
        child: Container(),
      ),
    );
  }
}

/// A transparent connector for start, end [TimelineNode] of the [Timeline].
///
/// This connector will be not displayed, it only occupies an area.
class TransparentConnector extends StatelessWidget {
  const TransparentConnector();

  @override
  Widget build(BuildContext context) => Container();
}

/// Apply indent to [child].
class _ConnectorIndent extends StatelessWidget {
  /// Creates a indent.
  ///
  /// The [direction]and [child] must be null. And [space], [indent] and [endIndent] must be null or non-negative.
  const _ConnectorIndent({
    Key key,
    @required this.direction,
    @required this.space,
    @required this.indent,
    @required this.endIndent,
    @required this.child,
  })  : assert(direction != null),
        assert(space == null || space >= 0),
        assert(indent == null || indent >= 0),
        assert(endIndent == null || endIndent >= 0),
        assert(child != null),
        super(key: key);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the size specified by this value.
  final double space;

  /// The amount of empty space to the leading edge of the connector.
  final double indent;

  /// The amount of empty space to the trailing edge of the connector.
  final double endIndent;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.vertical ? space : double.infinity,
      height: direction == Axis.vertical ? double.infinity : space,
      child: Center(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsetsDirectional.only(
                  top: indent,
                  bottom: endIndent,
                )
              : EdgeInsetsDirectional.only(
                  start: indent,
                  end: endIndent,
                ),
          child: child,
        ),
      ),
    );
  }
}
