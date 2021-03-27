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
        name: 'Container\nIndicator',
        item: ContainerIndicator(
          child: Container(
            width: 15.0,
            height: 15.0,
            color: Colors.blue,
          ),
        ),
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
        name: 'Decorated line\nConnector',
        item: SizedBox(
          height: 20.0,
          child: DecoratedLineConnector(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.lightBlueAccent.shade100],
              ),
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'Simple TimelineNode',
        item: SizedBox(
          height: 50.0,
          child: TimelineNode.simple(),
        ),
      ),
      _ComponentRow(
        name: 'Complex TimelineNode',
        item: SizedBox(
          height: 80.0,
          child: TimelineNode(
            indicator: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Complex'),
              ),
            ),
            startConnector: DashedLineConnector(),
            endConnector: SolidLineConnector(),
          ),
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
        name: 'ConnectionDirection.before',
        item: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connectedFromStyle(
              connectionDirection: ConnectionDirection.before,
              connectorStyleBuilder: (context, index) {
                return (index == 1)
                    ? ConnectorStyle.dashedLine
                    : ConnectorStyle.solidLine;
              },
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemExtent: 40.0,
              itemCount: 3,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'ConnectionDirection.after',
        item: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connectedFromStyle(
              connectionDirection: ConnectionDirection.after,
              connectorStyleBuilder: (context, index) {
                return (index == 1)
                    ? ConnectorStyle.dashedLine
                    : ConnectorStyle.solidLine;
              },
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemExtent: 40.0,
              itemCount: 3,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'ContentsAlign.basic',
        item: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: 3,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'ContentsAlign.reverse',
        item: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.reverse,
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('opposite\ncontents'),
              ),
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contents'),
                ),
              ),
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: 3,
            ),
          ),
        ),
      ),
      _ComponentRow(
        name: 'ContentsAlign.alternating',
        item: FixedTimeline.tileBuilder(
          builder: TimelineTileBuilder.connectedFromStyle(
            contentsAlign: ContentsAlign.alternating,
            oppositeContentsBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('opposite\ncontents'),
            ),
            contentsBuilder: (context, index) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Contents'),
              ),
            ),
            connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemCount: 3,
          ),
        ),
      ),
      _ComponentRow(
        name: 'Horizontal\nTimeline',
        item: SizedBox(
          height: 150,
          child: Timeline.tileBuilder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            builder: TimelineTileBuilder.fromStyle(
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
          child: Timeline.tileBuilder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            builder: TimelineTileBuilder.fromStyle(
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
          child: Timeline.tileBuilder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            builder: TimelineTileBuilder.fromStyle(
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
          child: Timeline.tileBuilder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            builder: TimelineTileBuilder.fromStyle(
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
          child: Timeline.tileBuilder(
            builder: TimelineTileBuilder.fromStyle(
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
    required String name,
    required Widget item,
  }) : super(
          children: [
            _ComponentName(name),
            _ComponentItem(child: item),
          ],
        );
}

class _ComponentItem extends StatelessWidget {
  const _ComponentItem({
    Key? key,
    required this.child,
  }) : super(key: key);

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
    Key? key,
  })  : assert(name.length > 0),
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
