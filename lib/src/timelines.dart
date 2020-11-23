import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timeline_theme.dart';
import 'timeline_tile_builder.dart';

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
  factory Timeline.tileBuilder({
    Key key,
    @required TimelineTileBuilder builder,
    Axis scrollDirection,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    // double itemExtent, TODO: fixedExtentTileBuilder?
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData theme,
  }) {
    assert(builder.itemCount == null || builder.itemCount >= 0);
    assert(semanticChildCount == null || semanticChildCount <= builder.itemCount);
    return Timeline.custom(
      key: key,
      childrenDelegate: SliverChildBuilderDelegate(
        builder.build,
        childCount: builder.itemCount,
        // TODO: apply some fields if needed.
      ),
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      // itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount ?? builder.itemCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      theme: theme,
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
    Axis scrollDirection,
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
    TimelineThemeData theme,
  })  : childrenDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        assert(scrollDirection == null || theme == null, 'Cannot provide both a scrollDirection and a theme.'),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
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
    Axis scrollDirection,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData theme,
  })  : assert(itemCount == null || itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        assert(scrollDirection == null || theme == null, 'Cannot provide both a scrollDirection and a theme.'),
        childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
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
  Timeline.custom({
    Key key,
    Axis scrollDirection,
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
    TimelineThemeData theme,
  })  : assert(childrenDelegate != null),
        assert(scrollDirection == null || theme == null, 'Cannot provide both a scrollDirection and a theme.'),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
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

  /// Default visual properties, like colors, size and spaces, for this timeline's component widgets.
  ///
  /// The default value of this property is the value of [TimelineThemeData.vertical()].
  final TimelineThemeData theme;

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
      data: theme ??
          TimelineThemeData(
            direction: scrollDirection,
          ),
      child: result,
    );
  }
}

/// A widget that displays its children in a one-dimensional array with timeline theme.
class FixedTimeline extends StatelessWidget {
  /// Creates a timeline flex layout.
  factory FixedTimeline.tileBuilder({
    Key key,
    @required TimelineTileBuilder builder,
    TimelineThemeData theme,
    Axis direction,
  }) {
    assert(builder != null);
    // TODO: how remove Builders?
    return FixedTimeline(
      children: [
        for (int i = 0; i < builder.itemCount; i++)
          Builder(
            builder: (context) => builder.build(context, i),
          ),
      ],
      theme: theme,
      direction: direction,
    );
  }

  /// Creates a timeline flex layout.
  const FixedTimeline({
    Key key,
    this.theme,
    this.direction,
    this.children = const [],
  })  : assert(direction == null || theme == null, 'Cannot provide both a direction and a theme.'),
        super(key: key);

  final TimelineThemeData theme;
  final Axis direction;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? theme?.direction ?? Axis.vertical;
    return TimelineTheme(
      data: theme ??
          TimelineThemeData(
            direction: direction,
          ),
      child: Flex(
        direction: direction,
        children: children,
      ),
    );
  }
}
