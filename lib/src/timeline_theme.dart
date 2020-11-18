import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timeline_node.dart';
import 'indicator_theme.dart';

class TimelineTheme extends StatelessWidget {
  const TimelineTheme({
    Key key,
    @required this.data,
    @required this.child,
  }) : super(key: key);

  /// Specifies the direction for descendant widgets.
  final TimelineThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static final TimelineThemeData _kFallbackTheme = TimelineThemeData.fallback();

  static TimelineThemeData of(BuildContext context) {
    final _InheritedTheme inheritedTheme = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.theme?.data ?? _kFallbackTheme;
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
    properties.add(DiagnosticsProperty<TimelineThemeData>('data', data, showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final TimelineTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _InheritedTheme ancestorTheme = context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme) ? child : TimelineTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

@immutable
class TimelineThemeData with Diagnosticable {
  /// Create a [TimelineThemeData] that's used to configure a [TimelineTheme].
  ///
  /// See also:
  ///
  ///  * [TimelineThemeData.vertical], which creates a vertical direction TimelineThemeData.
  ///  * [TimelineThemeData.horizontal], which creates a horizontal direction TimelineThemeData.
  factory TimelineThemeData({
    Axis direction,
    IndicatorThemeData indicatorTheme,
  }) {
    direction ??= Axis.vertical;
    indicatorTheme ??= const IndicatorThemeData();
    return TimelineThemeData.raw(
      direction: direction,
      indicatorTheme: indicatorTheme,
    );
  }

  /// The default direction theme. Same as [new TimelineThemeData.vertical].
  ///
  /// This is used by [TimelineTheme.of] when no theme has been specified.
  factory TimelineThemeData.fallback() => TimelineThemeData.vertical();

  /// Create a [TimelineThemeData] given a set of exact values. All the values must be
  /// specified. They all must also be non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [new TimelineThemeData] constructor.
  const TimelineThemeData.raw({
    @required this.direction,
    @required this.indicatorTheme,
  })  : assert(direction != null),
        assert(indicatorTheme != null);

  /// A default vertical theme.
  factory TimelineThemeData.vertical() => TimelineThemeData(
        direction: Axis.vertical,
      );

  /// A default horizontal theme.
  factory TimelineThemeData.horizontal() => TimelineThemeData(
        direction: Axis.horizontal,
      );

  final Axis direction;

  /// A theme for customizing the appearance and layout of [ThemedIndicatorComponent] widgets.
  final IndicatorThemeData indicatorTheme;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  TimelineThemeData copyWith({
    Axis direction,
    IndicatorThemeData indicatorTheme,
  }) {
    return TimelineThemeData.raw(
      direction: direction ?? this.direction,
      indicatorTheme: indicatorTheme ?? this.indicatorTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TimelineThemeData lerp(TimelineThemeData a, TimelineThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return TimelineThemeData.raw(
      direction: t < 0.5 ? a.direction : b.direction,
      indicatorTheme: IndicatorThemeData.lerp(a.indicatorTheme, b.indicatorTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return other is TimelineThemeData && other.direction == direction && other.indicatorTheme == indicatorTheme;
  }

  @override
  int get hashCode {
    // Warning: For the sanity of the reader, please make sure these properties
    // are in the exact same order as in operator == and in the raw constructor
    // and in the order of fields in the class and in the lerp() method.
    final List<Object> values = <Object>[
      direction,
      indicatorTheme,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final TimelineThemeData defaultData = TimelineThemeData.fallback();
    properties.add(DiagnosticsProperty<Axis>('direction', direction,
        defaultValue: defaultData.direction, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<IndicatorThemeData>(
      'indicatorTheme',
      indicatorTheme,
      defaultValue: defaultData.indicatorTheme,
      level: DiagnosticLevel.debug,
    ));
  }
}
