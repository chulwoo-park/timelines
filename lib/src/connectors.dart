import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'connector_theme.dart';
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

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [ConnectorThemeData.color] is used. If that is also null, then [ThemeData.color] is
  /// used.
  @override
  final Color color;

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

  @override
  Widget build(BuildContext context) {
    // TODO: apply other properties
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final color = getEffectiveColor(context);
    switch (direction) {
      case Axis.vertical:
        return Center(
          child: Container(
            width: thickness,
            color: color,
          ),
        );
      case Axis.horizontal:
        return Center(
          child: Container(
            height: thickness,
            color: color,
          ),
        );
    }

    throw ArgumentError('invalid direction: $direction');
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
