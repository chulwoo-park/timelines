import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timeline_theme.dart';

enum ConnectorStyle {
  solid,
  transparent,
}

// TODO
class SolidLineConnector extends StatelessWidget {
  final Axis direction;
  final double thickness;
  final Color color;

  const SolidLineConnector({
    Key key,
    this.direction,
    this.thickness,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final thickness = this.thickness ?? 2.0;
    final color = this.color ?? Colors.blue;
    switch (direction) {
      case Axis.vertical:
        return Container(
          width: thickness,
          color: color,
        );
      case Axis.horizontal:
        return Container(
          height: thickness,
          color: color,
        );
    }

    throw ArgumentError('invalid direction: $direction');
  }
}

class TransparentConnector extends StatelessWidget {
  const TransparentConnector();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
