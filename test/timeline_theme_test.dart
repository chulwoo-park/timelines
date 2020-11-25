import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timelines/timelines.dart';

void main() {
  testWidgets('Fallback theme', (WidgetTester tester) async {
    var capturedTheme;
    await tester.pumpWidget(Builder(
      builder: (BuildContext localContext) {
        capturedTheme = TimelineTheme.of(localContext);
        return SizedBox.shrink();
      },
    ));

    expect(
      capturedTheme,
      equals(TimelineThemeData.fallback()),
    );
  });

  testWidgets(
    'Same TimelineThemeData reapplied does not trigger descendants rebuilds',
    (WidgetTester tester) async {
      testBuildCalled = 0;
      TimelineThemeData themeData = TimelineThemeData(color: Colors.white);

      Widget buildTheme() {
        return TimelineTheme(
          data: themeData,
          child: const Test(),
        );
      }

      await tester.pumpWidget(buildTheme());
      expect(testBuildCalled, 1);

      // Pump the same widgets again.
      await tester.pumpWidget(buildTheme());
      // No repeated build calls to the child since it's the same theme data.
      expect(testBuildCalled, 1);

      // New instance of theme data but still the same content.
      themeData = TimelineThemeData(color: Colors.white);
      await tester.pumpWidget(buildTheme());
      // Still no repeated calls.
      expect(testBuildCalled, 1);

      // Different now.
      themeData = TimelineThemeData(color: Colors.red);
      await tester.pumpWidget(buildTheme());
      // Should call build again.
      expect(testBuildCalled, 2);
    },
  );
}

int testBuildCalled = 0;

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    testBuildCalled += 1;
    return Container(
      decoration: BoxDecoration(
        color: TimelineTheme.of(context).color,
      ),
    );
  }
}
