import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timelines Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Timelines Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addEvent() {
    // TODO: implements
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineThemeData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 20) {
              return TimelineTheme(
                data: TimelineThemeData.horizontal(),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TimelineTile(
                        child: Card(
                          child: Text("BYE"),
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            final child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  width: 200.0,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
              ),
            );
            if (index == 3) {
              return TimelineTile(
                child: child,
                indicatorPosition: 0.5,
                indicatorChild: DotIndicator(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              );
            }

            return TimelineTile(
              child: child,
              indicatorPosition: 0.5,
              drawStartLine: index > 0,
              drawEndLine: index < 19,
            );
          },
          itemCount: 21,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addEvent,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
