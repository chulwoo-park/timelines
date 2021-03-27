import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'timeline_theme.dart';
import 'timeline_tile_builder.dart';

/// A scrollable timeline of widgets arranged linearly.
class Timeline extends BoxScrollView {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to
  /// estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually
  /// create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the
  /// timeline view's children are created in advance, or all at once when the
  /// [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on
  /// demand using this constructor's `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildBuilderDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildBuilderDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildBuilderDelegate.addSemanticIndexes] property. None
  /// may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you
  /// are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  factory Timeline.tileBuilder({
    Key? key,
    required TimelineTileBuilder builder,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    // double itemExtent, TODO: fixedExtentTileBuilder?
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  }) {
    assert(builder.itemCount >= 0);
    assert(
        semanticChildCount == null || semanticChildCount <= builder.itemCount);
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
  /// This constructor is appropriate for timeline views with a small number of
  /// children because constructing the [List] requires doing work for every
  /// child that could possibly be displayed in the timeline view instead of
  /// just those children that are actually visible.
  ///
  /// It is usually more efficient to create children on demand using
  /// [Timeline.builder] because it will create the widget children lazily as
  /// necessary.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildListDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildListDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildListDelegate.addSemanticIndexes] property. None may be null.
  Timeline({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : childrenDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
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
  /// This constructor is appropriate for list views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to
  /// estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually
  /// create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the
  /// timeline view's children are created in advance, or all at once when the
  /// [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on
  /// demand using this constructor's `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildBuilderDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildBuilderDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildBuilderDelegate.addSemanticIndexes] property. None
  /// may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you
  /// are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  Timeline.builder({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : assert(itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
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
  /// For example, a custom child model can control the algorithm used to
  /// estimate the size of children that are not actually visible.
  ///
  /// See also:
  ///
  ///  * This works similarly to [ListView.custom].
  Timeline.custom({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    required this.childrenDelegate,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
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

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use
  /// of the foreknowledge of the children's extent to save work, for example
  /// when the scroll position changes drastically.
  final double? itemExtent;

  /// A delegate that provides the children for the [Timeline].
  ///
  /// The [Timeline.custom] constructor lets you specify this delegate
  /// explicitly. The [Timeline] and [Timeline.builder] constructors create a
  /// [childrenDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
  /// respectively.
  final SliverChildDelegate childrenDelegate;

  /// Default visual properties, like colors, size and spaces, for this
  /// timeline's component widgets.
  ///
  /// The default value of this property is the value of
  /// [TimelineThemeData.vertical()].
  final TimelineThemeData? theme;

  @override
  Widget buildChildLayout(BuildContext context) {
    Widget result;
    if (itemExtent != null) {
      result = SliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: itemExtent!,
      );
    } else {
      result = SliverList(delegate: childrenDelegate);
    }

    var theme;
    if (this.theme != null) {
      theme = this.theme;
    } else if (scrollDirection != TimelineTheme.of(context).direction) {
      theme = TimelineTheme.of(context).copyWith(direction: scrollDirection);
    }

    if (theme != null) {
      return TimelineTheme(
        data: theme,
        child: result,
      );
    } else {
      return result;
    }
  }
}

/// A widget that displays its children in a one-dimensional array with
/// timeline theme.
class FixedTimeline extends StatelessWidget {
  /// Creates a timeline flex layout.
  factory FixedTimeline.tileBuilder({
    Key? key,
    required TimelineTileBuilder builder,
    TimelineThemeData? theme,
    Axis? direction,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) {
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
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a timeline flex layout.
  ///
  /// The [direction], [verticalDirection] arguments must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality],
  /// if any. If there is no ambient directionality, and a text direction is
  /// going to be necessary to decide which direction to lay the children in or
  /// to disambiguate `start` or `end` values for the main or cross axis
  /// directions, the [textDirection] must not be null.
  const FixedTimeline({
    Key? key,
    this.theme,
    this.direction,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.children = const [],
  })  : assert(direction == null || theme == null,
            'Cannot provide both a direction and a theme.'),
        super(key: key);

  /// Default visual properties, like colors, size and spaces, for this
  /// timeline's component widgets.
  ///
  /// The default value of this property is the value of
  /// [TimelineThemeData.vertical()].
  final TimelineThemeData? theme;

  /// The direction to use as the main axis.
  final Axis? direction;

  /// The widgets below this widget in the tree.
  ///
  /// If this list is going to be mutated, it is usually wise to put a [Key] on
  /// each of the child widgets, so that the framework can match old
  /// configurations to new configurations and maintain the underlying
  /// render objects.
  ///
  /// See also:
  ///
  ///  * [MultiChildRenderObjectWidget.children]
  final List<Widget> children;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize mainAxisSize;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left).
  ///
  /// If the [direction] is [Axis.horizontal], and there's more than one child,
  /// then the [textDirection] (or the ambient [Directionality]) must not
  /// be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], there's more than one child, then
  /// the [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// The content will be clipped (or not) according to this option.
  ///
  /// See the enum Clip for details of all possible options and their common
  /// use cases.
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? this.theme?.direction ?? Axis.vertical;

    Widget result = Flex(
      direction: direction,
      children: children,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );

    var theme;
    if (this.direction != null) {
      if (direction != TimelineTheme.of(context).direction) {
        theme = TimelineTheme.of(context).copyWith(direction: this.direction);
      }
    } else if (this.theme != null) {
      theme = this.theme;
    }

    if (theme != null) {
      return TimelineTheme(
        data: theme,
        child: result,
      );
    } else {
      return result;
    }
  }
}
