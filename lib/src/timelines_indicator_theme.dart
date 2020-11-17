import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timelines/src/timelines_theme.dart';

/// Controls the default color and size of indicators in a widget subtree.
///
/// The timelines indicator theme is honored by [CircleIndicator] and [T O D O] widgets.
class TimelinesIndicatorTheme extends InheritedTheme {
  /// Creates an timelines indicator theme that controls the color and size of descendant widgets.
  ///
  /// Both [data] and [child] arguments must not be null.
  const TimelinesIndicatorTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  /// The color and size to use for timelines indicators in this subtree.
  final TimelinesIndicatorThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Defaults to the current [TimelinesThemeData.indicatorTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  ///  TimelinesIndicatorThemeData theme = TimelinesIndicatorTheme.of(context);
  /// ```
  static TimelinesIndicatorThemeData of(BuildContext context) {
    final TimelinesIndicatorThemeData timelinesIndicatorThemeData =
        _getInheritedTimelinesIndicatorThemeData(context).resolve(context);
    return timelinesIndicatorThemeData.isConcrete
        ? timelinesIndicatorThemeData
        : timelinesIndicatorThemeData.copyWith(
            size: timelinesIndicatorThemeData.size ?? const TimelinesIndicatorThemeData.fallback().size,
            color: timelinesIndicatorThemeData.color ?? const TimelinesIndicatorThemeData.fallback().color,
          );
  }

  static TimelinesIndicatorThemeData _getInheritedTimelinesIndicatorThemeData(BuildContext context) {
    final TimelinesIndicatorTheme timelinesIndicatorTheme =
        context.dependOnInheritedWidgetOfExactType<TimelinesIndicatorTheme>();
    return timelinesIndicatorTheme?.data ?? const TimelinesIndicatorThemeData.fallback();
  }

  @override
  bool updateShouldNotify(TimelinesIndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final TimelinesIndicatorTheme iconTheme = context.findAncestorWidgetOfExactType<TimelinesIndicatorTheme>();
    return identical(this, iconTheme) ? child : TimelinesIndicatorTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Defines the color and size of indicators.
///
/// Used by [TimelinesIndicatorTheme] to control the color and size of indicators in a
/// widget subtree.
///
/// To obtain the current timelines indicator theme, use [TimelinesIndicatorTheme.of]. To convert an timelines indicator
/// theme to a version with all the fields filled in, use [new TimelinesIndicatorThemeData.fallback].
@immutable
class TimelinesIndicatorThemeData with Diagnosticable {
  /// Creates an timelines indicator theme data.
  const TimelinesIndicatorThemeData({this.color, this.size});

  /// Creates an timelines indicator them with some reasonable default values.
  ///
  /// The [color] is blue and the [size] is 15.0.
  const TimelinesIndicatorThemeData.fallback()
      : color = Colors.blue,
        size = 15.0;

  /// Creates a copy of this timelines indicator theme but with the given fields replaced with
  /// the new values.
  TimelinesIndicatorThemeData copyWith({Color color, double opacity, double size}) {
    return TimelinesIndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  /// Called by [TimelinesIndicatorTheme.of] to convert this instance to an [TimelinesINdicatorThemeData]
  /// that fits the given [BuildContext].
  ///
  /// This method gives the ambient [TimelinesIndicatorThemeData] a chance to update itself,
  /// after it's been retrieved by [TimelinesIndicatorTheme.of], and before being returned as
  /// the final result.
  ///
  /// The default implementation returns this [TimelinesIndicatorThemeData] as-is.
  TimelinesIndicatorThemeData resolve(BuildContext context) => this;

  /// Whether all the properties of this object are non-null.
  bool get isConcrete => color != null && size != null;

  /// The default color for indicators.
  final Color color;

  /// The default size for indicators.
  final double size;

  /// Linearly interpolate between two themes.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TimelinesIndicatorThemeData lerp(TimelinesIndicatorThemeData a, TimelinesIndicatorThemeData b, double t) {
    assert(t != null);
    return TimelinesIndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is TimelinesIndicatorThemeData && other.color == color && other.size == size;
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
