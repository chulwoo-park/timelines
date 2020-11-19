import 'package:flutter/material.dart';

import 'indicator_theme.dart';
import 'timeline_theme.dart';

/// [TimelineNode]'s indicator
mixin Indicator on Widget {
  /// {@template timelines.indicator.position}
  /// If this is null, then the [IndicatorThemeData.position] is used. If that is also null, then this defaults to
  /// [TimelineThemeData.indicatorPosition].
  /// {@endtemplate}
  double get position;
  double getEffectivePosition(BuildContext context) {
    return position ?? IndicatorTheme.of(context).position ?? TimelineTheme.of(context).indicatorPosition;
  }
}

/// A widget that displays an dot.
class DotIndicator extends StatelessWidget with Indicator, ThemedIndicatorComponent {
  /// Creates a dot indicator.
  ///
  /// The [size] must be null or non-negative.
  const DotIndicator({
    Key key,
    this.size = 15.0,
    this.color,
    this.position,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(key: key);

  /// The size of the dot in logical pixels.
  ///
  /// {@macro timelines.indicator.size}
  @override
  final double size;

  /// The color to use when drawing the dot.
  ///
  /// {@macro timelines.indicator.color}
  @override
  final Color color;

  /// The position of a indicator between the two connectors.
  ///
  /// {@macro timelines.indicator.position}
  @override
  final double position;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = getEffectiveSize(context);
    final effectiveColor = getEffectiveColor(context);
    return Center(
      child: SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: DecoratedBox(
          child: child,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: effectiveColor,
          ),
        ),
      ),
    );
  }
}

/// A widget that displays an outlined dot.
class OutlinedDotIndicator extends StatelessWidget with Indicator, ThemedIndicatorComponent {
  /// Creates a outlined dot indicator.
  ///
  /// The [size] must be null or non-negative.
  const OutlinedDotIndicator({
    Key key,
    this.size = 15.0,
    this.color,
    this.borderWidth = 1.0,
    this.position,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(key: key);

  /// The size of the outlined dot in logical pixels.
  ///
  /// {@macro timelines.indicator.size}
  @override
  final double size;

  /// The color to use when drawing the outlined dot.
  ///
  /// {@macro timelines.indicator.color}
  @override
  final Color color;

  /// The width of this outline, in logical pixels.
  final double borderWidth;

  /// The position of a indicator between the two connectors.
  ///
  /// {@macro timelines.indicator.position}
  @override
  final double position;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = getEffectiveSize(context);
    final effectiveColor = getEffectiveColor(context);
    return Center(
      child: SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: DecoratedBox(
          child: child,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: effectiveColor,
              width: borderWidth,
            ),
          ),
        ),
      ),
    );
  }
}
