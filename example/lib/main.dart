import 'theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timelines/timelines.dart';

import 'component_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timelines Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineThemeData(
        indicatorTheme: IndicatorThemeData(size: 15.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timelines Example'),
        ),
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _NavigationCard(
              name: 'Components',
              navigationBuilder: (_) => ComponentPage(),
            ),
            _NavigationCard(
              name: 'Theme',
              navigationBuilder: (_) => ThemePage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    Key key,
    @required this.name,
    this.navigationBuilder,
  }) : super(key: key);

  final String name;
  final WidgetBuilder navigationBuilder;

  Future<T> _navigate<T>(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => navigationBuilder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _navigate(context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(name),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAppBar extends StatelessWidget with PreferredSizeWidget {
  TitleAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
