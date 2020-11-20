import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

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
  /// The contents aligned end of timeline. And the opposite contents aligned start of timeline.
  ///
  /// Example:
  ///
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  basic,

  /// The contents aligned start of timeline. And the opposite contents aligned end of timeline.
  ///
  /// Example:
  ///
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  reverse,

  /// The contents and opposite contents displayed alternating.
  ///
  /// Example:
  ///
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  alternating,
}

/// Types of indicators displayed into timeline
///
/// See also:
///
///  * [TimelineTileBuilder.fromStyle]
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

/// A delegate that supplies [TimelineTile] for timeline using a builder callback.
///
/// The widgets returned from the builder callback are automatically wrapped in [AutomaticKeepAlive] widgets if
/// [addAutomaticKeepAlives] is true (the default) and in [RepaintBoundary] widgets if [addRepaintBoundaries] is true
/// (also the default).
///
/// ## Accessibility
///
/// The [CustomScrollView] requires that its semantic children are annotated using [IndexedSemantics]. This is done by
/// default in the delegate with the `addSemanticIndexes` parameter set to true.
///
/// If multiple delegates are used in a single scroll view, then the indexes will not be correct by default. The
/// `semanticIndexOffset` can be used to offset the semantic indexes of each delegate so that the indexes are
/// monotonically increasing. For example, if a scroll view contains two delegates where the first has 10 children
/// contributing semantics, then the second delegate should offset its children by 10.
///
/// See also:
///
///  * [IndexedSemantics], for an example of manually annotating child nodes with semantic indexes.
class TimelineTileBuilder extends SliverChildBuilderDelegate {
  /// Creates tiles from style. Each tile
  ///
  /// [BoxFit]
  ///
  /// See also:
  ///  * [IndicatorStyle],
  ///  * [ConnectorStyle],
  ///  * [ContentsAlign],
  factory TimelineTileBuilder.fromStyle({
    IndexedWidgetBuilder contentsBuilder,
    IndexedWidgetBuilder oppositeContentsBuilder,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    IndicatorStyle indicatorStyle = IndicatorStyle.dot,
    ConnectorStyle connectorStyle = ConnectorStyle.solidLine,
    double itemExtent,
    double nodePosition,
    double indicatorPosition,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    final effectiveContentsBuilder = (context, index) {
      switch (contentsAlign) {
        case ContentsAlign.alternating:
          if (index.isOdd) {
            return oppositeContentsBuilder(context, index);
          }

          return contentsBuilder(context, index);
        case ContentsAlign.reverse:
          return oppositeContentsBuilder(context, index);
        case ContentsAlign.basic:
        default:
          return contentsBuilder(context, index);
      }
    };
    final effectiveOppositeContentsBuilder = (context, index) {
      switch (contentsAlign) {
        case ContentsAlign.alternating:
          if (index.isOdd) {
            return contentsBuilder(context, index);
          }

          return oppositeContentsBuilder(context, index);
        case ContentsAlign.reverse:
          return contentsBuilder(context, index);
        case ContentsAlign.basic:
        default:
          return oppositeContentsBuilder(context, index);
      }
    };
    final effectiveIndicatorBuilder = (_, __) {
      switch (indicatorStyle) {
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
    final startConnectorBuilder = (_, __) {
      switch (connectorStyle) {
        case ConnectorStyle.solidLine:
          return SolidLineConnector();
        case ConnectorStyle.dashedLine:
          return DashedLineConnector();
        case ConnectorStyle.transparent:
        default:
          return TransparentConnector();
      }
    };
    final endConnectorBuilder = (_, __) {
      switch (connectorStyle) {
        case ConnectorStyle.solidLine:
          return SolidLineConnector();
        case ConnectorStyle.dashedLine:
          return DashedLineConnector();
        case ConnectorStyle.transparent:
        default:
          return TransparentConnector();
      }
    };
    return TimelineTileBuilder._(
      (context, index) => TimelineTile(
        mainAxisExtent: itemExtent,
        node: TimelineNode(
          indicator: effectiveIndicatorBuilder?.call(context, index) ?? ContainerIndicator(),
          startConnector: startConnectorBuilder?.call(context, index),
          endConnector: endConnectorBuilder?.call(context, index),
          position: nodePosition,
          indicatorPosition: indicatorPosition,
        ),
        contents: effectiveContentsBuilder?.call(context, index),
        oppositeContents: effectiveOppositeContentsBuilder?.call(context, index),
      ),
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );
  }

  const TimelineTileBuilder._(
    IndexedWidgetBuilder builder, {
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) : super(
          builder,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        );
}

/// A scrollable timeline of widgets arranged linearly.
class Timeline extends BoxScrollView {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large (or infinite) number of children because the builder
  /// is called only for those children that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than or equal to zero and less than
  /// `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the timeline view's children are created in
  /// advance, or all at once when the [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on demand using this constructor's
  /// `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the [SliverChildBuilderDelegate.addAutomaticKeepAlives]
  /// property. The `addRepaintBoundaries` argument corresponds to the [SliverChildBuilderDelegate.addRepaintBoundaries]
  /// property. The `addSemanticIndexes` argument corresponds to the [SliverChildBuilderDelegate.addSemanticIndexes]
  /// property. None may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  factory Timeline.timelineTile({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required TimelineTileBuilder itemBuilder,
    double itemExtent,
    int itemCount,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    double nodePosition,
    double indicatorPosition,
  }) {
    assert(itemCount == null || itemCount >= 0);
    assert(semanticChildCount == null || semanticChildCount <= itemCount);
    return Timeline.custom(
      key: key,
      childrenDelegate: itemBuilder,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount ?? itemCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a scrollable, linear array of widgets from an explicit [List].
  ///
  /// This constructor is appropriate for timeline views with a small number of children because constructing the [List]
  /// requires doing work for every child that could possibly be displayed in the timeline view instead of just those
  /// children that are actually visible.
  ///
  /// It is usually more efficient to create children on demand using [Timeline.builder] because it will create the
  /// widget children lazily as necessary.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the [SliverChildListDelegate.addAutomaticKeepAlives]
  /// property. The `addRepaintBoundaries` argument corresponds to the [SliverChildListDelegate.addRepaintBoundaries]
  /// property. The `addSemanticIndexes` argument corresponds to the [SliverChildListDelegate.addSemanticIndexes]
  /// property. None may be null.
  Timeline({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : childrenDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? children.length,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large (or infinite) number of children because the builder
  /// is called only for those children that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than or equal to zero and less than
  /// `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the timeline view's children are created in
  /// advance, or all at once when the [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on demand using this constructor's
  /// `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the [SliverChildBuilderDelegate.addAutomaticKeepAlives]
  /// property. The `addRepaintBoundaries` argument corresponds to the [SliverChildBuilderDelegate.addRepaintBoundaries]
  /// property. The `addSemanticIndexes` argument corresponds to the [SliverChildBuilderDelegate.addSemanticIndexes]
  /// property. None may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  Timeline.builder({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemCount == null || itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Creates a scrollable, linear array of widgets with a custom child model.
  ///
  /// For example, a custom child model can control the algorithm used to estimate the size of children that are not
  /// actually visible.
  ///
  /// See also:
  ///
  ///  * This works similarly to [ListView.custom].
  const Timeline.custom({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    @required this.childrenDelegate,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(childrenDelegate != null),
        super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// If non-null, forces the children to have the given extent in the scroll direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children determine their own extent because the
  /// scrolling machinery can make use of the foreknowledge of the children's extent to save work, for example when the
  /// scroll position changes drastically.
  final double itemExtent;

  /// A delegate that provides the children for the [Timeline].
  ///
  /// The [Timeline.custom] constructor lets you specify this delegate explicitly. The [Timeline] and [Timeline.builder]
  /// constructors create a [childrenDelegate] that wraps the given [List] and [IndexedWidgetBuilder], respectively.
  final SliverChildDelegate childrenDelegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    Widget result;
    if (itemExtent != null) {
      result = SliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: itemExtent,
      );
    } else {
      result = SliverList(delegate: childrenDelegate);
    }

    return TimelineTheme(
      data: TimelineThemeData(
        direction: scrollDirection,
      ),
      child: result,
    );
  }
}
