import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timelines/src/timeline_node.dart';
import 'package:timelines/src/indicators.dart';
import 'package:timelines/src/timeline_theme.dart';

/// Controls the default color and size of indicators in a widget subtree.
///
/// The indicator theme is honored by [TimelineNode], [DotIndicator] and [TO DO] widgets.
class IndicatorTheme extends InheritedTheme {
  /// Creates an indicator theme that controls the color and size of descendant widgets.
  ///
  /// Both [data] and [child] arguments must not be null.
  const IndicatorTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  /// The color and size to use for indicators in this subtree.
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
    final IndicatorThemeData indicatorThemeData = _getInheritedIndicatorThemeData(context).resolve(context);
    return indicatorThemeData.isConcrete
        ? indicatorThemeData
        : indicatorThemeData.copyWith(
            size: indicatorThemeData.size ?? const IndicatorThemeData.fallback().size,
            color: indicatorThemeData.color ?? const IndicatorThemeData.fallback().color,
          );
  }

  static IndicatorThemeData _getInheritedIndicatorThemeData(BuildContext context) {
    final IndicatorTheme indicatorTheme = context.dependOnInheritedWidgetOfExactType<IndicatorTheme>();
    return indicatorTheme?.data ?? const IndicatorThemeData.fallback();
  }

  @override
  bool updateShouldNotify(IndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final IndicatorTheme iconTheme = context.findAncestorWidgetOfExactType<IndicatorTheme>();
    return identical(this, iconTheme) ? child : IndicatorTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Defines the color and size of indicators.
///
/// Used by [IndicatorTheme] to control the color and size of indicators in a
/// widget subtree.
///
/// To obtain the current indicator theme, use [IndicatorTheme.of]. To convert an indicator
/// theme to a version with all the fields filled in, use [new IndicatorThemeData.fallback].
@immutable
class IndicatorThemeData with Diagnosticable {
  /// Creates an indicator theme data.
  const IndicatorThemeData({this.color, this.size});

  /// Creates an indicator them with some reasonable default values.
  ///
  /// The [color] is blue and the [size] is 15.0.
  const IndicatorThemeData.fallback()
      : color = Colors.blue,
        size = 15.0;

  /// Creates a copy of this indicator theme but with the given fields replaced with
  /// the new values.
  IndicatorThemeData copyWith({Color color, double opacity, double size}) {
    return IndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  /// Called by [IndicatorTheme.of] to convert this instance to an [IndicatorThemeData]
  /// that fits the given [BuildContext].
  ///
  /// This method gives the ambient [IndicatorThemeData] a chance to update itself,
  /// after it's been retrieved by [IndicatorTheme.of], and before being returned as
  /// the final result.
  ///
  /// The default implementation returns this [IndicatorThemeData] as-is.
  IndicatorThemeData resolve(BuildContext context) => this;

  /// Whether all the properties of this object are non-null.
  bool get isConcrete => color != null && size != null;

  /// The default color for indicators.
  final Color color;

  /// The default size for indicators.
  final double size;

  /// Linearly interpolate between two themes.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static IndicatorThemeData lerp(IndicatorThemeData a, IndicatorThemeData b, double t) {
    assert(t != null);
    return IndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is IndicatorThemeData && other.color == color && other.size == size;
  }

  @override
  int get hashCode => hashValues(color, size);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null, level: DiagnosticLevel.debug));
    properties.add(DoubleProperty('size', size, defaultValue: null, level: DiagnosticLevel.debug));
  }
}
