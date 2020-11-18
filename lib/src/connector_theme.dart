import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timelines/src/connectors.dart';

import 'timeline_theme.dart';

/// Defines the visual properties of [SolidLineConnector], connectors
/// inside [TimelineNode].
///
/// Descendant widgets obtain the current [ConnectorThemeData] object using
/// `ConnectorTheme.of(context)`. Instances of [ConnectorThemeData]
/// can be customized with [ConnectorThemeData.copyWith].
///
/// Typically a [ConnectorThemeData] is specified as part of the overall
/// [TimelineTheme] with [TimelineThemeData.connectorTheme].
///
/// All [ConnectorThemeData] properties are `null` by default. When null,
/// the widgets will provide their own defaults.
///
/// See also:
///
///  * [TimelineThemeData], which describes the overall theme information for the
///    timeline.
@immutable
class ConnectorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ConnectorTheme] or
  /// [TimelineThemeData.connectorTheme].
  const ConnectorThemeData({
    this.color,
    this.space,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  /// The color of [SolidLineConnector]s and connectors inside [TimelineNode]s, and so forth.
  final Color color;

  /// This represents the amount of horizontal or vertical space the connector takes up.
  final double space;

  /// The thickness of the line drawn within the connector.
  final double thickness;

  /// The amount of empty space at the start edge of [SolidLineConnector].
  final double indent;

  /// The amount of empty space at the end edge of [SolidLineConnector].
  final double endIndent;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  ConnectorThemeData copyWith({
    Color color,
    double space,
    double thickness,
    double indent,
    double endIndent,
  }) {
    return ConnectorThemeData(
      color: color ?? this.color,
      space: space ?? this.space,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
      endIndent: endIndent ?? this.endIndent,
    );
  }

  /// Linearly interpolate between two Connector themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ConnectorThemeData lerp(ConnectorThemeData a, ConnectorThemeData b, double t) {
    assert(t != null);
    return ConnectorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      space: lerpDouble(a?.space, b?.space, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
      endIndent: lerpDouble(a?.endIndent, b?.endIndent, t),
    );
  }

  @override
  int get hashCode {
    return hashValues(
      color,
      space,
      thickness,
      indent,
      endIndent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ConnectorThemeData &&
        other.color == color &&
        other.space == space &&
        other.thickness == thickness &&
        other.indent == indent &&
        other.endIndent == endIndent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DoubleProperty('space', space, defaultValue: null));
    properties.add(DoubleProperty('thickness', thickness, defaultValue: null));
    properties.add(DoubleProperty('indent', indent, defaultValue: null));
    properties.add(DoubleProperty('endIndent', endIndent, defaultValue: null));
  }
}

/// An inherited widget that defines the configuration for [SolidLineConnector]s, connectors inside [TimelineNode]s.
class ConnectorTheme extends InheritedTheme {
  /// Creates a connector theme that controls the configurations for [SolidLineConnector]s, connectors inside
  /// [TimelineNode]s.
  const ConnectorTheme({
    Key key,
    @required this.data,
    Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  /// The properties for descendant [SolidLineConnector]s, connectors inside [TimelineNode]s.
  final ConnectorThemeData data;

  /// The closest instance of this class's [data] value that encloses the given context.
  ///
  /// If there is no ancestor, it returns [TimelineThemeData.connectorTheme]. Applications can assume that the returned
  /// value will not be null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ConnectorThemeData theme = ConnectorTheme.of(context);
  /// ```
  static ConnectorThemeData of(BuildContext context) {
    final ConnectorTheme connectorTheme = context.dependOnInheritedWidgetOfExactType<ConnectorTheme>();
    return connectorTheme?.data; // TODO ?? TimelineTheme.of(context).connectorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ConnectorTheme ancestorTheme = context.findAncestorWidgetOfExactType<ConnectorTheme>();
    return identical(this, ancestorTheme) ? child : ConnectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ConnectorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

mixin ThemedConnectorComponent on Widget {
  Axis get direction;
  Axis getEffectiveDirection(BuildContext context) {
    return this.direction ?? TimelineTheme.of(context).direction;
  }

  double get thickness;
  double getEffectiveThickness(BuildContext context) {
    return this.thickness ?? ConnectorTheme.of(context).thickness ?? 2.0;
  }

  double get space;
  double getEffectiveSpace(BuildContext context) {
    return this.space ?? ConnectorTheme.of(context).space;
  }

  double get indent;
  double getEffectiveIndent(BuildContext context) {
    return this.indent ?? ConnectorTheme.of(context).indent ?? 0.0;
  }

  double get endIndent;
  double getEffectiveEndIndent(BuildContext context) {
    return this.endIndent ?? ConnectorTheme.of(context).endIndent ?? 0.0;
  }

  Color get color;
  Color getEffectiveColor(BuildContext context) {
    return this.color ?? ConnectorTheme.of(context).color; // TODO ?? TimelineTheme.of(context).color;
  }
}
