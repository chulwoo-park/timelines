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
    this.size,
    this.color,
    this.border,
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

  /// The border to use when drawing the dot's outline.
  final BoxBorder border;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = getEffectiveSize(context);
    final effectiveColor = getEffectiveColor(context);
    return Center(
      child: Container(
        width: effectiveSize ?? ((child == null) ? 15.0 : null),
        height: effectiveSize ?? ((child == null) ? 15.0 : null),
        child: child,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveColor,
          border: border,
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
    this.size,
    this.color,
    this.backgroundColor,
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

  /// The color to use when drawing the outline of dot.
  ///
  /// {@macro timelines.indicator.color}
  @override
  final Color color;

  /// The color to use when drawing the dot in outline.
  ///
  /// {@macro timelines.indicator.color}
  final Color backgroundColor;

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
    return DotIndicator(
      size: size,
      color: backgroundColor ?? Colors.transparent,
      position: position,
      border: Border.all(
        color: color ?? getEffectiveColor(context),
        width: borderWidth,
      ),
      child: child,
    );
  }
}
