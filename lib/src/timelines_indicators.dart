import 'package:flutter/material.dart';
import 'package:timelines/src/timelines_indicator_theme.dart';

class CircleIndicator extends StatelessWidget {
  final double size;

  final Color color;

  final Widget child;

  const CircleIndicator({
    Key key,
    this.size = 15.0,
    this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? TimelinesIndicatorTheme.of(context).color;
    return Container(
      width: size,
      height: size,
      child: child,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
