import 'package:flutter/material.dart';

import 'connectors.dart';
import 'indicators.dart';
import 'timeline_node.dart';
import 'timeline_theme.dart';
import 'timeline_tile.dart';

/// How a contents displayed be into timeline.
///
/// See also:
///  * [TimelineTileBuilder.fromStyle]
enum ContentsAlign {
  /// The contents aligned end of timeline. And the opposite contents aligned
  /// start of timeline.
  ///
  /// Example:
  /// ```
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  /// ```
  basic,

  /// The contents aligned start of timeline. And the opposite contents aligned
  /// end of timeline.
  ///
  /// Example:
  ///
  /// ```
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  /// ```
  reverse,

  /// The contents and opposite contents displayed alternating.
  ///
  /// Example:
  /// ```
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  /// ```
  alternating,
}

/// An enum that representing the direction the connector is connected through
/// the builder.
///
/// See also:
///
///  * [TimelineTileBuilder.connected], which is how the builder uses this enum
///  to connect each connector.
///  * [TimelineTileBuilder.connectedFromStyle], which is how the builder uses
///  this enum to connect each connector.
enum ConnectionDirection { before, after }

/// An enum that representing the connector type in [TimelineNode].
///
/// For example, if the timeline direction is Axis.horizontal and the text
/// direction is LTR:
/// ```
///   start   end
///   ---- O ----
/// ```
/// See also:
///
///  * [ConnectedConnectorBuilder], which is use this.
enum ConnectorType { start, end }

/// An enum that determines the style of indicator in timeline tile builder.
///
/// TODO: replace with class to support parameters
///
/// See also:
///
///  * [TimelineTileBuilder.fromStyle], which is use this.
///  * [TimelineTileBuilder.connectedFromStyle], which is use this.
enum IndicatorStyle {
  /// Draw dot indicator.
  dot,

  /// Draw outlined dot indicator.
  outlined,

  /// Draw container indicator. TODO: need child to builds...
  container,

  /// Draw transparent indicator. (invisible indicator)
  transparent,
}

/// Types of connectors displayed into timeline
///
/// See also:
/// * [TimelineTileBuilder.fromStyle].
enum ConnectorStyle {
  /// Draw solid line connector.
  solidLine,

  /// Draw dashed line connector.
  dashedLine,

  /// Draw transparent connector. (invisible connector)
  transparent,
}

/// Signature for a function that creates a connected connector widget for a
/// given index and type, e.g., in a timeline tile builder.
typedef ConnectedConnectorBuilder = Widget? Function(
    BuildContext context, int index, ConnectorType type);

/// Signature for a function that creates a typed value for a given index, e.g.,
/// in a timeline tile builder.
///
/// Used by [TimelineTileBuilder] that use lazily-generated typed value.
typedef IndexedValueBuilder<T> = T Function(BuildContext context, int index);

/// WARNING: The interface of this class is not yet clear. It may change
/// frequently.
///
/// A delegate that supplies [TimelineTile] for timeline using a builder
/// callback.
class TimelineTileBuilder {
  /// Create a connected tile builder, which builds tiles using each component
  /// builder.
  ///
  /// Check below for how to build:
  ///
  /// Original build system:
  ///
  /// ```
  /// |            <-- builder(0)
  /// O contents1  <-- builder(0)
  /// |            <-- builder(0)
  /// |            <-- builder(1)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(1)
  /// ```
  ///
  /// Connected build system(before):
  ///
  /// ```
  /// |            <-- draw if provided [firstConnectorBuilder]
  /// O contents1  <-- builder(0)
  /// |            <-- builder(1)
  /// |            <-- builder(1)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(2)
  /// |            <-- builder(2)
  /// O            <-- builder(2)
  /// |            <-- builder(3)
  /// ..
  /// |            <-- draw if provided [lastConnectorBuilder]
  /// ```
  ///
  ///
  /// Connected build system(after):
  ///
  /// ```
  /// |            <-- draw if provided [firstConnectorBuilder]
  /// O contents1  <-- builder(0)
  /// |            <-- builder(0)
  /// |            <-- builder(0)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(1)
  /// |            <-- builder(1)
  /// O            <-- builder(2)
  /// |            <-- builder(2)
  /// ..
  /// |            <-- draw if provided [lastConnectorBuilder]
  /// ```
  ///
  /// The above example can be made similar by just set the
  /// [TimelineNode.indicatorPosition] as 0 or 1, but the contents position may
  /// be limited.
  ///
  /// {@macro timelines.itemExtentBuilder}
  ///
  /// See also:
  ///
  ///  * [TimelineTileBuilder.connectedFromStyle], which builds connected tiles
  ///  from style.
  factory TimelineTileBuilder.connected({
    required int itemCount,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    ConnectionDirection connectionDirection = ConnectionDirection.after,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    NullableIndexedWidgetBuilder? indicatorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
    WidgetBuilder? firstConnectorBuilder,
    WidgetBuilder? lastConnectorBuilder,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: indicatorBuilder,
      startConnectorBuilder: _createConnectedStartConnectorBuilder(
        connectionDirection: connectionDirection,
        firstConnectorBuilder: firstConnectorBuilder,
        connectorBuilder: connectorBuilder,
      ),
      endConnectorBuilder: _createConnectedEndConnectorBuilder(
        connectionDirection: connectionDirection,
        lastConnectorBuilder: lastConnectorBuilder,
        connectorBuilder: connectorBuilder,
        itemCount: itemCount,
      ),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a connected tile builder, which builds tiles using each style.
  ///
  /// {@macro timelines.itemExtentBuilder}
  ///
  /// See also:
  ///
  ///  * [TimelineTileBuilder.connected], which builds connected tiles.
  ///  * [TimelineTileBuilder.fromStyle], which builds tiles from style.
  factory TimelineTileBuilder.connectedFromStyle({
    @required required int itemCount,
    ConnectionDirection connectionDirection = ConnectionDirection.after,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    IndexedValueBuilder<IndicatorStyle>? indicatorStyleBuilder,
    IndexedValueBuilder<ConnectorStyle>? connectorStyleBuilder,
    ConnectorStyle firstConnectorStyle = ConnectorStyle.solidLine,
    ConnectorStyle lastConnectorStyle = ConnectorStyle.solidLine,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: (context, index) => _createStyledIndicatorBuilder(
          indicatorStyleBuilder?.call(context, index))(context),
      startConnectorBuilder: _createConnectedStartConnectorBuilder(
        connectionDirection: connectionDirection,
        firstConnectorBuilder: (context) =>
            _createStyledConnectorBuilder(firstConnectorStyle)(context),
        connectorBuilder: (context, index, __) => _createStyledConnectorBuilder(
            connectorStyleBuilder?.call(context, index))(context),
      ),
      endConnectorBuilder: _createConnectedEndConnectorBuilder(
        connectionDirection: connectionDirection,
        lastConnectorBuilder: (context) =>
            _createStyledConnectorBuilder(lastConnectorStyle)(context),
        connectorBuilder: (context, index, __) => _createStyledConnectorBuilder(
            connectorStyleBuilder?.call(context, index))(context),
        itemCount: itemCount,
      ),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a tile builder, which builds tiles using each style.
  ///
  /// {@macro timelines.itemExtentBuilder}
  /// TODO: style each index like fromStyleBuilder
  ///
  /// See also:
  ///
  ///  * [IndicatorStyle]
  ///  * [ConnectorStyle]
  ///  * [ContentsAlign]
  factory TimelineTileBuilder.fromStyle({
    required int itemCount,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    IndicatorStyle indicatorStyle = IndicatorStyle.dot,
    ConnectorStyle connectorStyle = ConnectorStyle.solidLine,
    ConnectorStyle endConnectorStyle = ConnectorStyle.solidLine,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: (context, index) =>
          _createStyledIndicatorBuilder(indicatorStyle)(context),
      startConnectorBuilder: (context, _) =>
          _createStyledConnectorBuilder(connectorStyle)(context),
      endConnectorBuilder: (context, _) =>
          _createStyledConnectorBuilder(connectorStyle)(context),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a tile builder, which builds tiles using each component builder.
  ///
  /// {@template timelines.itemExtentBuilder}
  /// If each item has a fixed extent, use [itemExtent], and if each item has a
  /// different extent, use [itemExtentBuilder].
  /// {@endtemplate}
  ///
  /// TODO: need refactoring, is it has many builders...?
  factory TimelineTileBuilder({
    required int itemCount,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    NullableIndexedWidgetBuilder? indicatorBuilder,
    NullableIndexedWidgetBuilder? startConnectorBuilder,
    NullableIndexedWidgetBuilder? endConnectorBuilder,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<bool?>? nodeItemOverlapBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    IndexedValueBuilder<TimelineThemeData>? themeBuilder,
  }) {
    assert(
      itemExtent == null || itemExtentBuilder == null,
      'Cannot provide both a itemExtent and a itemExtentBuilder.',
    );

    final effectiveContentsBuilder = _createAlignedContentsBuilder(
      align: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
    );
    final effectiveOppositeContentsBuilder = _createAlignedContentsBuilder(
      align: contentsAlign,
      contentsBuilder: oppositeContentsBuilder,
      oppositeContentsBuilder: contentsBuilder,
    );

    return TimelineTileBuilder._(
      (context, index) {
        final tile = TimelineTile(
          mainAxisExtent: itemExtent ?? itemExtentBuilder?.call(context, index),
          node: TimelineNode(
            indicator: indicatorBuilder?.call(context, index) ??
                Indicator.transparent(),
            startConnector: startConnectorBuilder?.call(context, index),
            endConnector: endConnectorBuilder?.call(context, index),
            overlap: nodeItemOverlapBuilder?.call(context, index),
            position: nodePositionBuilder?.call(context, index),
            indicatorPosition: indicatorPositionBuilder?.call(context, index),
          ),
          contents: effectiveContentsBuilder(context, index),
          oppositeContents: effectiveOppositeContentsBuilder(context, index),
        );

        final theme = themeBuilder?.call(context, index);
        if (theme != null) {
          return TimelineTheme(
            data: theme,
            child: tile,
          );
        } else {
          return tile;
        }
      },
      itemCount: itemCount,
    );
  }

  const TimelineTileBuilder._(
    this._builder, {
    required this.itemCount,
  }) : assert(itemCount >= 0);

  final IndexedWidgetBuilder _builder;
  final int itemCount;

  Widget build(BuildContext context, int index) {
    return _builder(context, index);
  }

  static NullableIndexedWidgetBuilder _createConnectedStartConnectorBuilder({
    ConnectionDirection? connectionDirection,
    WidgetBuilder? firstConnectorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
  }) =>
      (context, index) {
        if (index == 0) {
          if (firstConnectorBuilder != null) {
            return firstConnectorBuilder.call(context);
          } else {
            return null;
          }
        }

        if (connectionDirection == ConnectionDirection.before) {
          return connectorBuilder?.call(context, index, ConnectorType.start);
        } else {
          return connectorBuilder?.call(
              context, index - 1, ConnectorType.start);
        }
      };

  static NullableIndexedWidgetBuilder _createConnectedEndConnectorBuilder({
    ConnectionDirection? connectionDirection,
    WidgetBuilder? lastConnectorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
    required int itemCount,
  }) =>
      (context, index) {
        if (index == itemCount - 1) {
          if (lastConnectorBuilder != null) {
            return lastConnectorBuilder.call(context);
          } else {
            return null;
          }
        }

        if (connectionDirection == ConnectionDirection.before) {
          return connectorBuilder?.call(context, index + 1, ConnectorType.end);
        } else {
          return connectorBuilder?.call(context, index, ConnectorType.end);
        }
      };

  static NullableIndexedWidgetBuilder _createAlignedContentsBuilder({
    required ContentsAlign align,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
  }) {
    return (context, index) {
      switch (align) {
        case ContentsAlign.alternating:
          if (index.isOdd) {
            return oppositeContentsBuilder?.call(context, index);
          }

          return contentsBuilder?.call(context, index);
        case ContentsAlign.reverse:
          return oppositeContentsBuilder?.call(context, index);
        case ContentsAlign.basic:
        default:
          return contentsBuilder?.call(context, index);
      }
    };
  }

  static WidgetBuilder _createStyledIndicatorBuilder(IndicatorStyle? style) {
    return (_) {
      switch (style) {
        case IndicatorStyle.dot:
          return Indicator.dot();
        case IndicatorStyle.outlined:
          return Indicator.outlined();
        case IndicatorStyle.container:
          return Indicator.widget();
        case IndicatorStyle.transparent:
        default:
          return Indicator.transparent();
      }
    };
  }

  static WidgetBuilder _createStyledConnectorBuilder(ConnectorStyle? style) {
    return (_) {
      switch (style) {
        case ConnectorStyle.solidLine:
          return Connector.solidLine();
        case ConnectorStyle.dashedLine:
          return Connector.dashedLine();
        case ConnectorStyle.transparent:
        default:
          return Connector.transparent();
      }
    };
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// The widgets returned from the builder callback are automatically wrapped in
/// [AutomaticKeepAlive] widgets if [addAutomaticKeepAlives] is true
/// (the default) and in [RepaintBoundary] widgets if [addRepaintBoundaries] is
/// true (also the default).
///
/// ## Accessibility
///
/// The [CustomScrollView] requires that its semantic children are annotated
/// using [IndexedSemantics]. This is done by default in the delegate with the
/// `addSemanticIndexes` parameter set to true.
///
/// If multiple delegates are used in a single scroll view, then the indexes
/// will not be correct by default. The `semanticIndexOffset` can be used to
/// offset the semantic indexes of each delegate so that the indexes are
/// monotonically increasing. For example, if a scroll view contains two
/// delegates where the first has 10 children contributing semantics, then the
/// second delegate should offset its children by 10.
///
/// See also:
///
///  * [IndexedSemantics], for an example of manually annotating child nodes
///  with semantic indexes.
class TimelineTileBuilderDelegate extends SliverChildBuilderDelegate {
  TimelineTileBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    ChildIndexGetter? findChildIndexCallback,
    int? childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback =
        _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          builder,
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );
}
