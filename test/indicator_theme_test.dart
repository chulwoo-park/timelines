import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timelines/timelines.dart';

void main() {
  group('TimelineTheme, IndicatorTheme overrides', () {
    Widget buildFrame({
      Indicator indicator = const DotIndicator(),
      OutlinedDotIndicator outlinedDotIndicator = const OutlinedDotIndicator(),
      ContainerIndicator containerIndicator = const ContainerIndicator(),
      IndicatorThemeData indicatorTheme,
      IndicatorThemeData overallIndicatorTheme,
      TimelineThemeData timelineTheme,
    }) {
      final Widget child = Builder(builder: (BuildContext context) {
        if (indicatorTheme == null) {
          return indicator;
        } else {
          return IndicatorTheme(
            data: indicatorTheme,
            child: indicator,
          );
        }
      });

      return TimelineTheme(
        data: (timelineTheme ?? TimelineThemeData()).copyWith(
          indicatorTheme: overallIndicatorTheme,
        ),
        child: child,
      );
    }

    testWidgets('Passing no IndicatorTheme returns defaults',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(indicator: DotIndicator()));
      var container = _getIndicatorContainer<DotIndicator>(tester);

      expect(container.decoration.color, Colors.blue);
      expect(container.constraints.maxWidth, 15.0);
      expect(container.constraints.maxHeight, 15.0);

      await tester.pumpWidget(buildFrame(indicator: OutlinedDotIndicator()));
      container = _getIndicatorContainer<OutlinedDotIndicator>(tester);

      expect(container.decoration.borderColor, Colors.blue);
      expect(container.constraints.maxWidth, 15.0);
      expect(container.constraints.maxHeight, 15.0);

      await tester.pumpWidget(buildFrame(indicator: ContainerIndicator()));
      container = _getIndicatorContainer<ContainerIndicator>(tester);

      expect(container.constraints, isNull);
    });

    testWidgets('Indicator uses values from IndicatorTheme',
        (WidgetTester tester) async {
      final indicatorTheme = _indicatorThemeData();
      await tester.pumpWidget(buildFrame(
        indicator: DotIndicator(),
        indicatorTheme: indicatorTheme,
      ));
      var container = _getIndicatorContainer<DotIndicator>(tester);
      expect(container.decoration.color, indicatorTheme.color);
      expect(container.constraints.maxWidth, indicatorTheme.size);
      expect(container.constraints.maxHeight, indicatorTheme.size);

      await tester.pumpWidget(buildFrame(
        indicator: OutlinedDotIndicator(),
        indicatorTheme: indicatorTheme,
      ));
      container = _getIndicatorContainer<OutlinedDotIndicator>(tester);
      expect(container.decoration.borderColor, indicatorTheme.color);
      expect(container.constraints.maxWidth, indicatorTheme.size);
      expect(container.constraints.maxHeight, indicatorTheme.size);

      await tester.pumpWidget(buildFrame(
        indicator: ContainerIndicator(),
        indicatorTheme: indicatorTheme,
      ));
      container = _getIndicatorContainer<ContainerIndicator>(tester);
      expect(container.constraints.maxWidth, indicatorTheme.size);
      expect(container.constraints.maxHeight, indicatorTheme.size);
    });

    testWidgets('Indicator properties take priority over theme',
        (WidgetTester tester) async {
      const Color propColor = Colors.orange;
      const double propSize = 50.0;
      await tester.pumpWidget(buildFrame(
        indicatorTheme: _indicatorThemeData(),
        indicator: DotIndicator(
          color: propColor,
          size: propSize,
        ),
      ));
      var container = _getIndicatorContainer<DotIndicator>(tester);
      expect(container.decoration.color, propColor);
      expect(container.constraints.maxWidth, propSize);
      expect(container.constraints.maxHeight, propSize);
    });

    testWidgets(
        'IndicatorTheme properties take priority over TimelineTheme properties',
        (WidgetTester tester) async {
      final indicatorTheme = _indicatorThemeData();
      final timelineThemeData = _timelineThemeData().copyWith(
        indicatorTheme: indicatorTheme,
      );
      await tester.pumpWidget(buildFrame(
        indicator: DotIndicator(),
        timelineTheme: timelineThemeData,
      ));
      var container = _getIndicatorContainer<DotIndicator>(tester);
      expect(container.decoration.color, indicatorTheme.color);

      await tester.pumpWidget(buildFrame(
        indicator: OutlinedDotIndicator(),
        timelineTheme: timelineThemeData,
      ));
      container = _getIndicatorContainer<OutlinedDotIndicator>(tester);
      expect(container.decoration.borderColor, indicatorTheme.color);
    });

    testWidgets(
        'TimelineThemeData properties are used when no IndicatorTheme is set',
        (WidgetTester tester) async {
      final TimelineThemeData themeData = _timelineThemeData();

      await tester.pumpWidget(buildFrame(
        indicator: DotIndicator(),
        timelineTheme: themeData,
      ));
      var container = _getIndicatorContainer<DotIndicator>(tester);
      expect(container.decoration.color, themeData.color);
    });
  });
}

Container _getIndicatorContainer<T>(WidgetTester tester) {
  return tester.widget<Container>(find.descendant(
    of: find.byType(T),
    matching: find.byType(Container),
  ));
}

TimelineThemeData _timelineThemeData() {
  return TimelineThemeData(color: Colors.pink);
}

IndicatorThemeData _indicatorThemeData() {
  return IndicatorThemeData(
    color: Colors.white,
    size: 100.0,
    // position: position,
  );
}

extension on Decoration {
  Color get color => (this as BoxDecoration).color;
  Color get borderColor => (this as BoxDecoration).border.top.color;
}
