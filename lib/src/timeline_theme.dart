import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'connector_theme.dart';
import 'indicator_theme.dart';
import 'timelines.dart';

/// Applies a theme to descendant timeline widgets.
///
/// A theme describes the colors and typographic choices of an application.
///
/// Descendant widgets obtain the current theme's [TimelineThemeData] object
/// using [TimelineTheme.of]. When a widget uses [TimelineTheme.of], it is
/// automatically rebuilt if the theme later changes, so that the changes can be
/// applied.
///
/// See also:
///
///  * [TimelineThemeData], which describes the actual configuration of a theme.
class TimelineTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const TimelineTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// Specifies the direction for descendant widgets.
  final TimelineThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static final TimelineThemeData _kFallbackTheme = TimelineThemeData.fallback();

  /// The data from the closest [TimelineTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [new ThemeData.fallback] if there is no [Theme] in the given
  /// build context.
  ///
  /// When the [TimelineTheme] is actually created in the same `build` function
  /// (possibly indirectly, e.g. as part of a [Timeline]), the `context`
  /// argument to the `build` function can't be used to find the [TimelineTheme]
  /// (since it's "above" the widget being returned). In such cases, the
  /// following technique with a [Builder] can be used to provide a new scope
  /// with a [BuildContext] that is "under" the [TimelineTheme]:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   // TODO: replace to Timeline
  ///   return TimelineTheme(
  ///     data: TimelineThemeData.vertical(),
  ///     child: Builder(
  ///       // Create an inner BuildContext so that we can refer to the Theme with TimelineTheme.of().
  ///       builder: (BuildContext context) {
  ///         return Center(
  ///           child: TimelineNode(
  ///             direction: TimelineTheme.of(context).direction,
  ///             child: Text('Example'),
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  static TimelineThemeData of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.theme.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: IndicatorTheme(
        data: data.indicatorTheme,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TimelineThemeData>('data', data, showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final TimelineTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : TimelineTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

/// Defines the configuration of the overall visual [TimelineTheme] for a
/// [Timeline] or a widget subtree within the app.
///
/// The [Timeline] theme property can be used to configure the appearance of the
/// entire timeline. Widget subtree's within an timeline can override the
/// timeline's theme by including a [TimelineTheme] widget at the top of the
/// subtree.
///
/// Widgets whose appearance should align with the overall theme can obtain the
/// current theme's configuration with [TimelineTheme.of].
///
/// The static [TimelineTheme.of] method finds the [TimelineThemeData] value
/// specified for the nearest [BuildContext] ancestor. This lookup is
/// inexpensive, essentially just a single HashMap access. It can sometimes be a
/// little confusing because [TimelineTheme.of] can not see a [TimelineTheme]
/// widget that is defined in the current build method's context. To overcome
/// that, create a new custom widget for the subtree that appears below the new
/// [TimelineTheme], or insert a widget that creates a new BuildContext, like
/// [Builder].
///
/// {@tool snippet}
/// In this example, the [Container] widget uses [Theme.of] to retrieve the
/// color from the theme's [color] to draw an amber square.
/// The [Builder] widget separates the parent theme's [BuildContext] from the
/// child's [BuildContext].
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/theme_data.png)
///
/// ```dart
/// TimelineTheme(
///   data: TimelineThemeData(
///     color: Colors.red,
///   ),
///   child: Builder(
///     builder: (BuildContext context) {
///       return Container(
///         width: 100,
///         height: 100,
///         color: TimelineTheme.of(context).color,
///       );
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
@immutable
class TimelineThemeData with Diagnosticable {
  /// Create a [TimelineThemeData] that's used to configure a [TimelineTheme].
  ///
  /// See also:
  ///
  ///  * [TimelineThemeData.vertical], which creates a vertical direction
  ///  TimelineThemeData.
  ///  * [TimelineThemeData.horizontal], which creates a horizontal direction
  ///  TimelineThemeData.
  factory TimelineThemeData({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    IndicatorThemeData? indicatorTheme,
    ConnectorThemeData? connectorTheme,
  }) {
    direction ??= Axis.vertical;
    color ??= Colors
        .blue; // TODO: Need to change the default color to the theme color?
    nodePosition ??= 0.5;
    nodeItemOverlap ??= false;
    indicatorPosition ??= 0.5;
    indicatorTheme ??= IndicatorThemeData();
    connectorTheme ??= ConnectorThemeData();
    return TimelineThemeData.raw(
      direction: direction,
      color: color,
      nodePosition: nodePosition,
      nodeItemOverlap: nodeItemOverlap,
      indicatorPosition: indicatorPosition,
      indicatorTheme: indicatorTheme,
      connectorTheme: connectorTheme,
    );
  }

  /// The default direction theme. Same as [new TimelineThemeData.vertical].
  ///
  /// This is used by [TimelineTheme.of] when no theme has been specified.
  factory TimelineThemeData.fallback() => TimelineThemeData.vertical();

  /// Create a [TimelineThemeData] given a set of exact values. All the values
  /// must be specified. They all must also be non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create
  /// intermediate themes based on two themes created with the
  /// [new TimelineThemeData] constructor.
  const TimelineThemeData.raw({
    required this.direction,
    required this.color,
    required this.nodePosition,
    required this.nodeItemOverlap,
    required this.indicatorPosition,
    required this.indicatorTheme,
    required this.connectorTheme,
  });

  /// A default vertical theme.
  factory TimelineThemeData.vertical() => TimelineThemeData(
        direction: Axis.vertical,
      );

  /// A default horizontal theme.
  factory TimelineThemeData.horizontal() => TimelineThemeData(
        direction: Axis.horizontal,
      );

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color for major parts of the timeline (indicator, connector, etc)
  final Color color;

  /// The position for [TimelineNode] in [TimelineTile].
  ///
  /// Defaults to 0.5.
  final double nodePosition;

  /// Determine whether each connectors and indicator will overlap in
  /// [TimelineNode].
  ///
  /// When each connectors overlap, they are drawn from the center offset of the
  /// indicator.
  final bool nodeItemOverlap;

  /// The position for indicator in [TimelineNode].
  ///
  /// Defaults to 0.5.
  final double indicatorPosition;

  /// A theme for customizing the appearance and layout of
  /// [ThemedIndicatorComponent] widgets.
  final IndicatorThemeData indicatorTheme;

  /// A theme for customizing the appearance and layout of
  /// [ThemedConnectorComponent] widgets.
  final ConnectorThemeData connectorTheme;

  /// Creates a copy of this theme but with the given fields replaced with the
  /// new values.
  TimelineThemeData copyWith({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    IndicatorThemeData? indicatorTheme,
    ConnectorThemeData? connectorTheme,
  }) {
    return TimelineThemeData.raw(
      direction: direction ?? this.direction,
      color: color ?? this.color,
      nodePosition: nodePosition ?? this.nodePosition,
      nodeItemOverlap: nodeItemOverlap ?? this.nodeItemOverlap,
      indicatorPosition: indicatorPosition ?? this.indicatorPosition,
      indicatorTheme: indicatorTheme ?? this.indicatorTheme,
      connectorTheme: connectorTheme ?? this.connectorTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TimelineThemeData lerp(
      TimelineThemeData a, TimelineThemeData b, double t) {
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return TimelineThemeData.raw(
      direction: t < 0.5 ? a.direction : b.direction,
      color: Color.lerp(a.color, b.color, t)!,
      nodePosition: lerpDouble(a.nodePosition, b.nodePosition, t)!,
      nodeItemOverlap: t < 0.5 ? a.nodeItemOverlap : b.nodeItemOverlap,
      indicatorPosition:
          lerpDouble(a.indicatorPosition, b.indicatorPosition, t)!,
      indicatorTheme:
          IndicatorThemeData.lerp(a.indicatorTheme, b.indicatorTheme, t),
      connectorTheme:
          ConnectorThemeData.lerp(a.connectorTheme, b.connectorTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return other is TimelineThemeData &&
        other.direction == direction &&
        other.color == color &&
        other.nodePosition == nodePosition &&
        other.nodeItemOverlap == nodeItemOverlap &&
        other.indicatorPosition == indicatorPosition &&
        other.indicatorTheme == indicatorTheme &&
        other.connectorTheme == connectorTheme;
  }

  @override
  int get hashCode {
    // Warning: For the sanity of the reader, please make sure these properties
    // are in the exact same order as in operator == and in the raw constructor
    // and in the order of fields in the class and in the lerp() method.
    final values = <Object>[
      direction,
      color,
      nodePosition,
      nodeItemOverlap,
      indicatorPosition,
      indicatorTheme,
      connectorTheme,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final defaultData = TimelineThemeData.fallback();
    properties
      ..add(DiagnosticsProperty<Axis>('direction', direction,
          defaultValue: defaultData.direction, level: DiagnosticLevel.debug))
      ..add(ColorProperty('color', color,
          defaultValue: defaultData.color, level: DiagnosticLevel.debug))
      ..add(DoubleProperty('nodePosition', nodePosition,
          defaultValue: defaultData.nodePosition, level: DiagnosticLevel.debug))
      ..add(FlagProperty('nodeItemOverlap',
          value: nodeItemOverlap, ifTrue: 'overlap connector and indicator'))
      ..add(DoubleProperty('indicatorPosition', indicatorPosition,
          defaultValue: defaultData.indicatorPosition,
          level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<IndicatorThemeData>(
        'indicatorTheme',
        indicatorTheme,
        defaultValue: defaultData.indicatorTheme,
        level: DiagnosticLevel.debug,
      ))
      ..add(DiagnosticsProperty<ConnectorThemeData>(
        'connectorTheme',
        connectorTheme,
        defaultValue: defaultData.connectorTheme,
        level: DiagnosticLevel.debug,
      ));
  }
}
