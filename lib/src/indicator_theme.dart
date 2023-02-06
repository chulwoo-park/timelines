import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'indicators.dart';
import 'timeline_node.dart';
import 'timeline_theme.dart';

/// Defines the visual properties of [DotIndicator], indicators inside
/// [TimelineNode]s.
///
/// Descendant widgets obtain the current [IndicatorThemeData] object using
/// `IndicatorTheme.of(context)`. Instances of [IndicatorThemeData] can be
/// customized with [IndicatorThemeData.copyWith].
///
/// Typically a [IndicatorThemeData] is specified as part of the overall
/// [TimelineTheme] with [TimelineThemeData.indicatorTheme].
///
/// All [IndicatorThemeData] properties are `null` by default. When null, the
/// widgets will provide their own defaults.
///
/// See also:
///
///  * [TimelineThemeData], which describes the overall theme information for
///  the timeline.
@immutable
class IndicatorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [IndicatorTheme] or
  /// [TimelineThemeData.indicatorTheme].
  const IndicatorThemeData({
    this.color,
    this.size,
    this.position,
  });

  /// The color of [DotIndicator]s and indicators inside [TimelineNode]s, and so
  /// forth.
  final Color? color;

  /// The size of [DotIndicator]s and indicators inside [TimelineNode]s, and so
  /// forth in logical pixels.
  ///
  /// Indicators occupy a square with width and height equal to size.
  final double? size;

  /// A position of indicator inside both two connectors.
  final double? position;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  IndicatorThemeData copyWith({
    Color? color,
    double? size,
    double? position,
  }) {
    return IndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
    );
  }

  /// Linearly interpolate between two Indicator themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static IndicatorThemeData lerp(
      IndicatorThemeData? a, IndicatorThemeData? b, double t) {
    return IndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
      position: lerpDouble(a?.position, b?.position, t),
    );
  }

  @override
  int get hashCode => Object.hash(color, size, position);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is IndicatorThemeData &&
        other.color == color &&
        other.size == size &&
        other.position == position;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('size', size, defaultValue: null))
      ..add(DoubleProperty('position', size, defaultValue: null));
  }
}

/// Controls the default color and size of indicators in a widget subtree.
///
/// The indicator theme is honored by [TimelineNode], [DotIndicator] and
/// [OutlinedDotIndicator] widgets.
class IndicatorTheme extends InheritedTheme {
  /// Creates an indicator theme that controls the color and size for
  /// [DotIndicator]s, indicators inside [TimelineNode]s.
  const IndicatorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [DotIndicator]s, indicators inside
  /// [TimelineNode]s.
  final IndicatorThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Defaults to the current [TimelineThemeData.indicatorTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  ///  IndicatorThemeData theme = IndicatorTheme.of(context);
  /// ```
  static IndicatorThemeData of(BuildContext context) {
    final indicatorTheme =
        context.dependOnInheritedWidgetOfExactType<IndicatorTheme>();
    return indicatorTheme?.data ?? TimelineTheme.of(context).indicatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<IndicatorTheme>();
    return identical(this, ancestorTheme)
        ? child
        : IndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Indicator component configured through [IndicatorTheme]
mixin ThemedIndicatorComponent on PositionedIndicator {
  /// {@template timelines.indicator.color}
  /// Defaults to the current [IndicatorTheme] color, if any.
  ///
  /// If no [IndicatorTheme] and no [TimelineTheme] is specified, indicators
  /// will default to blue.
  /// {@endtemplate}
  Color? get color;
  Color getEffectiveColor(BuildContext context) {
    return color ??
        IndicatorTheme.of(context).color ??
        TimelineTheme.of(context).color;
  }

  /// {@template timelines.indicator.size}
  /// Indicators occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [IndicatorTheme] size, if any. If there is no
  /// [IndicatorTheme], or it does not specify an explicit size, then it
  /// defaults to own child size(0.0).
  /// {@endtemplate}
  double? get size;
  double? getEffectiveSize(BuildContext context) {
    return size ?? IndicatorTheme.of(context).size;
  }
}
