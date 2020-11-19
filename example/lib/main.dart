import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timelines/timelines.dart';

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
      data: TimelineThemeData(
        indicatorTheme: IndicatorThemeData(size: 15.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: 40.0),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ExampleRow(
                    [
                      Container(color: Colors.white),
                    ],
                  ),
                  ExampleRow(
                    [
                      Text('DotIndicator'),
                      DotIndicator(),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ExampleRow(
                    [
                      Text('SolidLineConnector'),
                      SizedBox(
                        height: 20.0,
                        child: SolidLineConnector(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ExampleRow(
                    [
                      Text('TimelineNode.simple'),
                      SizedBox(
                        height: 50.0,
                        child: TimelineNode.simple(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final contents = Card(
                    margin: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      width: 200.0,
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                  );

                  final now = DateTime.now();
                  final oppositeContents = Text(
                    '${now.hour}:${now.minute}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  );

                  var node;
                  if (index != 1) {
                    node = TimelineNode.simple(
                      indicatorPosition: 0.2,
                      indicatorSize: index == 6 ? 0 : 15.0,
                      drawStartConnector: index > 0,
                      indicatorChild: index == 2 ? _LoadingIndicatorChild() : null,
                    );
                  } else {
                    node = TimelineNode(
                      indicator: OutlinedDotIndicator(
                        borderWidth: 2.0,
                      ),
                      startConnector: SolidLineConnector(),
                      endConnector: SolidLineConnector(),
                      indicatorPosition: 0.2,
                    );
                  }

                  return TimelineTile(
                    node: node,
                    oppositeContents: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 26.0,
                          end: 20.0,
                        ),
                        child: oppositeContents,
                      ),
                    ),
                    contents: contents,
                  );
                },
                childCount: 20,
              ),
            ),
          ],
          // itemBuilder: (context, index) {
          //   if (index == 20) {
          //     return TimelineTheme(
          //       data: TimelineThemeData.horizontal(),
          //       child: SizedBox(
          //         height: 100,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           shrinkWrap: true,
          //           itemBuilder: (context, index) {
          //             return TimelineTile(
          //               node: TimelineNode.simple(),
          //               contents: Card(
          //                 child: Text("BYE"),
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     );
          //   }
          //
          //   BoxShape.circle;
          //   final child = Container(
          //     padding: EdgeInsets.all(20.0),
          //     width: 200.0,
          //     color: index.isOdd ? Colors.yellow : Colors.blue,
          //     child: Text(
          //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 4,
          //     ),
          //   );
          //   if (index == 3) {
          //     return TimelineTile(
          //       node: TimelineNode.simple(
          //         indicatorChild: Padding(
          //           padding: const EdgeInsets.all(4.0),
          //           child: CircularProgressIndicator(
          //             strokeWidth: 2.0,
          //             valueColor: AlwaysStoppedAnimation(Colors.white),
          //           ),
          //         ),
          //       ),
          //       contents: Card(
          //         child: Text("BYE"),
          //       ),
          //     );
          //   }
          //
          //   return TimelineTile(
          //     node: TimelineNode.simple(
          //       indicatorSize: index == 6 ? 0 : 15.0,
          //       drawStartConnector: index > 0,
          //       drawEndConnector: index < 19,
          //     ),
          //     contents: child,
          //   );
          // },
          // itemCount: 21,
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

class ExampleRow extends StatelessWidget {
  const ExampleRow(
    this.children, {
    Key key,
    this.width = 300,
    this.height = 30,
  }) : super(key: key);

  final List<Widget> children;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children
              .map(
                (child) => Flexible(
                  flex: 1,
                  child: child,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _LoadingIndicatorChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 8.0,
        height: 8.0,
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
