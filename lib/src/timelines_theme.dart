import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timelines_indicator_theme.dart';

class TimelinesTheme extends StatelessWidget {
  const TimelinesTheme({
    Key key,
    @required this.data,
    @required this.child,
  }) : super(key: key);

  /// Specifies the direction for descendant widgets.
  final TimelinesThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static final TimelinesThemeData _kFallbackTheme = TimelinesThemeData.fallback();

  static TimelinesThemeData of(BuildContext context) {
    final _InheritedTheme inheritedTheme = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.theme?.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: TimelinesIndicatorTheme(
        data: data.indicatorTheme,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TimelinesThemeData>('data', data, showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final TimelinesTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _InheritedTheme ancestorTheme = context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme) ? child : TimelinesTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

@immutable
class TimelinesThemeData with Diagnosticable {
  /// Create a [TimelinesThemeData] that's used to configure a [TimelinesTheme].
  ///
  /// See also:
  ///
  ///  * [TimelinesThemeData.vertical], which creates a vertical direction TimelinesThemeData.
  ///  * [TimelinesThemeData.horizontal], which creates a horizontal direction TimelinesThemeData.
  factory TimelinesThemeData({
    Axis direction,
    TimelinesIndicatorThemeData indicatorTheme,
  }) {
    direction ??= Axis.vertical;
    indicatorTheme ??= const TimelinesIndicatorThemeData();
    return TimelinesThemeData.raw(
      direction: direction,
      indicatorTheme: indicatorTheme,
    );
  }

  /// The default direction theme. Same as [new TimelinesThemeData.vertical].
  ///
  /// This is used by [TimelinesTheme.of] when no theme has been specified.
  factory TimelinesThemeData.fallback() => TimelinesThemeData.vertical();

  /// Create a [TimelinesThemeData] given a set of exact values. All the values must be
  /// specified. They all must also be non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [new TimelinesThemeData] constructor.
  const TimelinesThemeData.raw({
    @required this.direction,
    @required this.indicatorTheme,
  })  : assert(direction != null),
        assert(indicatorTheme != null);

  /// A default vertical theme.
  factory TimelinesThemeData.vertical() => TimelinesThemeData(
        direction: Axis.vertical,
      );

  /// A default horizontal theme.
  factory TimelinesThemeData.horizontal() => TimelinesThemeData(
        direction: Axis.horizontal,
      );

  final Axis direction;

  /// A theme for customizing the appearance and layout of [TimelinesIndicator]
  /// widgets.
  final TimelinesIndicatorThemeData indicatorTheme;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  TimelinesThemeData copyWith({
    Axis direction,
    TimelinesIndicatorThemeData indicatorTheme,
  }) {
    return TimelinesThemeData.raw(
      direction: direction ?? this.direction,
      indicatorTheme: indicatorTheme ?? this.indicatorTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TimelinesThemeData lerp(TimelinesThemeData a, TimelinesThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return TimelinesThemeData.raw(
      direction: t < 0.5 ? a.direction : b.direction,
      indicatorTheme: TimelinesIndicatorThemeData.lerp(a.indicatorTheme, b.indicatorTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return other is TimelinesThemeData && other.direction == direction && other.indicatorTheme == indicatorTheme;
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
    final TimelinesThemeData defaultData = TimelinesThemeData.fallback();
    properties.add(DiagnosticsProperty<Axis>('direction', direction,
        defaultValue: defaultData.direction, level: DiagnosticLevel.debug));
    properties.add(DiagnosticsProperty<TimelinesIndicatorThemeData>(
      'indicatorTheme',
      indicatorTheme,
      defaultValue: defaultData.indicatorTheme,
      level: DiagnosticLevel.debug,
    ));
  }
}
