import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timelines/timelines.dart';

void main() {
  Finder containerFinder<T>() => find.descendant(
        of: find.byType(T),
        matching: find.byType(Container),
      );

  BuildContext capturedContext;

  setUp(() {
    capturedContext = null;
  });
  final Widget singletonThemeSubtree = Builder(
    builder: (BuildContext localContext) {
      capturedContext = localContext;
      return Placeholder();
    },
  );

  // TODO remove Directionality
  // TODO and direction standalone. and get Theme direction check Directionality, Directionality.maybeOf
  testWidgets('ConnectorThemes are applied', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TimelineTheme(
          data: TimelineThemeData(
            connectorTheme: ConnectorThemeData(
              color: Colors.green,
              thickness: 10.0,
              space: 15.0,
              indent: 20.0,
            ),
          ),
          child: SolidLineConnector(),
        ),
      ),
    );

    var connector =
        tester.widget<Container>(containerFinder<SolidLineConnector>());
    expect(connector.color, Colors.green);
    expect(connector.constraints.maxWidth, 10.0);

    var indent = tester.widget<Padding>(find.ancestor(
      of: containerFinder<SolidLineConnector>(),
      matching: find.byType(Padding),
    ));

    var connectorContainer = tester.widget<SizedBox>(find.ancestor(
      of: containerFinder<SolidLineConnector>(),
      matching: find.byType(SizedBox),
    ));

    expect(connectorContainer.width, 15.0);
    expect(connectorContainer.height, null);
    expect((indent.padding as EdgeInsetsDirectional).top, 20.0);
    expect((indent.padding as EdgeInsetsDirectional).bottom, 20.0);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TimelineTheme(
          data: TimelineThemeData(
            direction: Axis.horizontal,
            connectorTheme: ConnectorThemeData(
              color: Colors.green,
              thickness: 10.0,
              space: 15.0,
              indent: 20.0,
            ),
          ),
          child: SolidLineConnector(),
        ),
      ),
    );

    indent = tester.widget<Padding>(find.ancestor(
      of: containerFinder<SolidLineConnector>(),
      matching: find.byType(Padding),
    ));

    connectorContainer = tester.widget<SizedBox>(find.ancestor(
      of: containerFinder<SolidLineConnector>(),
      matching: find.byType(SizedBox),
    ));

    expect(connectorContainer.width, null);
    expect(connectorContainer.height, 15.0);
    expect((indent.padding as EdgeInsetsDirectional).start, 20.0);
    expect((indent.padding as EdgeInsetsDirectional).end, 20.0);
  });
}
