import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'indicator_theme.dart';
import 'timeline_node.dart';
import 'timeline_theme.dart';
import 'util.dart';

/// Align the timeline node within the timeline tile.
enum TimelineNodeAlign {
  /// Align [TimelineTile.node] to start side.
  start,

  /// Align [TimelineTile.node] to end side.
  end,

  /// Align according to the [TimelineTile.nodePosition].
  basic,
}

/// A widget that displays timeline node and two contents.
///
/// The [contents] are displayed on the end side, and the [oppositeContents] are
/// displayed on the start side.
/// The [node] is displayed between the two.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    Key? key,
    this.direction,
    required this.node,
    this.nodeAlign = TimelineNodeAlign.basic,
    this.nodePosition,
    this.contents,
    this.oppositeContents,
    this.mainAxisExtent,
    this.crossAxisExtent,
  })  : assert(
          nodeAlign == TimelineNodeAlign.basic ||
              (nodeAlign != TimelineNodeAlign.basic && nodePosition == null),
          'Cannot provide both a nodeAlign and a nodePosition',
        ),
        assert(nodePosition == null || nodePosition >= 0),
        super(key: key);

  /// {@template timelines.direction}
  /// The axis along which the timeline scrolls.
  /// {@endtemplate}
  final Axis? direction;

  /// A widget that displays indicator and two connectors.
  final Widget node;

  /// Align the [node] within the timeline tile.
  ///
  /// If try to use indicators with different sizes in each timeline tile, the
  /// timeline node may be broken.
  /// This can be prevented by set [IndicatorThemeData.size] to an appropriate
  /// size.
  ///
  /// If [nodeAlign] is not [TimelineNodeAlign.basic], then [nodePosition] is
  /// ignored.
  final TimelineNodeAlign nodeAlign;

  /// A position of [node] inside both two contents.
  ///
  /// {@macro timelines.node.position}
  final double? nodePosition;

  /// The contents to display inside the timeline tile.
  final Widget? contents;

  /// The contents to display on the opposite side of the [contents].
  final Widget? oppositeContents;

  /// The extent of the child in the scrolling axis.
  /// If the scroll axis is vertical, this extent is the child's height. If the
  /// scroll axis is horizontal, this extent is the child's width.
  ///
  /// If non-null, forces the tile to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [mainAxisExtent] is more efficient than letting the tile
  /// determine their own extent because the because it don't use the Intrinsic
  /// widget([IntrinsicHeight]/[IntrinsicWidth]) when building.
  final double? mainAxisExtent;

  /// The extent of the child in the non-scrolling axis.
  ///
  /// If the scroll axis is vertical, this extent is the child's width. If the
  /// scroll axis is horizontal, this extent is the child's height.
  final double? crossAxisExtent;

  double _getEffectiveNodePosition(BuildContext context) {
    if (nodeAlign == TimelineNodeAlign.start) return 0.0;
    if (nodeAlign == TimelineNodeAlign.end) return 1.0;
    var nodePosition = this.nodePosition;
    nodePosition ??= (node is TimelineTileNode)
        ? (node as TimelineTileNode).getEffectivePosition(context)
        : TimelineTheme.of(context).nodePosition;
    return nodePosition;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: reduce direction check
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final nodeFlex = _getEffectiveNodePosition(context) * kFlexMultiplier;

    var minNodeExtent = TimelineTheme.of(context).indicatorTheme.size ?? 0.0;
    var items = [
      if (nodeFlex > 0)
        Expanded(
          flex: nodeFlex.toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerEnd
                : Alignment.bottomCenter,
            child: oppositeContents ?? SizedBox.shrink(),
          ),
        ),
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: direction == Axis.vertical ? minNodeExtent : 0.0,
          minHeight: direction == Axis.vertical ? 0.0 : minNodeExtent,
        ),
        child: node,
      ),
      if (nodeFlex < kFlexMultiplier)
        Expanded(
          flex: (kFlexMultiplier - nodeFlex).toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerStart
                : Alignment.topCenter,
            child: contents ?? SizedBox.shrink(),
          ),
        ),
    ];

    var result;
    switch (direction) {
      case Axis.vertical:
        result = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );

        if (mainAxisExtent != null) {
          result = SizedBox(
            width: crossAxisExtent,
            height: mainAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicHeight(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              width: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      case Axis.horizontal:
        result = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );
        if (mainAxisExtent != null) {
          result = SizedBox(
            width: mainAxisExtent,
            height: crossAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicWidth(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              height: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      default:
        throw ArgumentError.value(direction, '$direction is invalid.');
    }

    result = Align(
      child: result,
    );

    if (TimelineTheme.of(context).direction != direction) {
      result = TimelineTheme(
        data: TimelineTheme.of(context).copyWith(
          direction: direction,
        ),
        child: result,
      );
    }

    return result;
  }
}
