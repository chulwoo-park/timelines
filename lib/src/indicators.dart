import 'package:flutter/material.dart';

import '../timelines.dart';

/// [TimelineNode]'s indicator
mixin Indicator on Widget {
  /// {@template timelines.indicator.position}
  /// If this is null, then the [IndicatorThemeData.position] is used. If that is also null, then this defaults to 0.5.
  /// {@endtemplate}
  double get position;
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
    return Container(
      width: effectiveSize,
      height: effectiveSize,
      child: child,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveColor,
      ),
    );
  }
}
