import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'widget.dart';

class ComponentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final children = [
      _ComponentRow(
        name: 'Dot\nIndicator',
        item: DotIndicator(),
      ),
      _ComponentRow(
        name: 'Outlined dot\nIndicator',
        item: OutlinedDotIndicator(),
      ),
      _ComponentRow(
        name: 'Solid line\nConnector',
        item: SizedBox(
          height: 20.0,
          child: SolidLineConnector(),
        ),
      ),
      _ComponentRow(
        name: 'Dashed line\nConnector',
        item: SizedBox(
          height: 20.0,
          child: DashedLineConnector(),
        ),
      ),
      _ComponentRow(
        name: 'TimelineNode',
        item: SizedBox(
          height: 50.0,
          child: TimelineNode.simple(),
        ),
      ),
      _ComponentRow(
        name: 'TimelineTile',
        item: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('opposite\ncontents'),
          ),
          contents: Card(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text('contents'),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(),
            startConnector: SolidLineConnector(),
            endConnector: SolidLineConnector(),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Horizontal\nTimeline',
        item: SizedBox(
          height: 150,
          child: Timeline.timelineTile(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              itemCount: 20,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Styled node\nHorizontal\nTimeline',
        item: SizedBox(
          height: 150,
          child: Timeline.timelineTile(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              indicatorStyle: IndicatorStyle.outlined,
              connectorStyle: ConnectorStyle.dashedLine,
              itemCount: 20,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Reverse\nHorizontal\nTimeline',
        item: SizedBox(
          height: 150,
          child: Timeline.timelineTile(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              contentsAlign: ContentsAlign.reverse,
              itemCount: 20,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Alternating\nHorizontal\nTimeline',
        item: SizedBox(
          height: 150,
          child: Timeline.timelineTile(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              contentsAlign: ContentsAlign.alternating,
              itemCount: 20,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Vertical\nTimeline',
        item: SizedBox(
          height: 500,
          child: Timeline.timelineTile(
            itemBuilder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              contentsAlign: ContentsAlign.alternating,
              indicatorStyle: IndicatorStyle.outlined,
              connectorStyle: ConnectorStyle.dashedLine,
              itemCount: 10,
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: TitleAppBar('Components'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          children: children,
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(0.3),
          },
        ),
      ),
    );
  }
}

class _ComponentRow extends TableRow {
  _ComponentRow({
    String name,
    Widget item,
  }) : super(
          children: [
            _ComponentName(name),
            _ComponentItem(child: item),
          ],
        );
}

class _ComponentItem extends StatelessWidget {
  const _ComponentItem({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 65.0,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}

class _ComponentName extends StatelessWidget {
  const _ComponentName(
    this.name, {
    Key key,
  })  : assert(name != null && name.length > 0),
        super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return _ComponentItem(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            child: Text(name),
          ),
        ),
      ),
    );
  }
}
