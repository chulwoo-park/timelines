import 'package:flutter/material.dart';

import '../timelines.dart';

/// A widget that displays an dot.
class DotIndicator extends StatelessWidget with ThemedIndicatorComponent {
  /// Creates a dot indicator.
  ///
  /// The [size] must be null or non-negative.
  const DotIndicator({
    Key key,
    this.size,
    this.color,
    this.child,
  })  : assert(size == null || size >= 0),
        super(key: key);

  /// The size of the dot in logical pixels.
  ///
  /// Dots occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [IndicatorTheme] size, if any. If there is no [IndicatorTheme], or it does not specify an
  /// explicit size, then it defaults to 15.0.
  @override
  final double size;

  /// The color to use when drawing the dot.
  ///
  /// Defaults to the current [IndicatorTheme] color, if any.
  ///
  /// If no [IndicatorTheme] and no [TimelineTheme] is specified, dots will default to blue.
  @override
  final Color color;

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
