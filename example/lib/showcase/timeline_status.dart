import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../widget.dart';

const kTileHeight = 50.0;

class TimelineStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('Timeline Status'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              _Timeline1(),
              SizedBox(width: 12.0),
              _Timeline2(),
              SizedBox(width: 12.0),
              _Timeline3(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Timeline1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = _TimelineStatus.values;
    return Flexible(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
            color: Color(0xffd3d3d3),
          ),
          indicatorTheme: IndicatorThemeData(
            size: 15.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        builder: TimelineTileBuilder.connected(
          contentsBuilder: (_, __) => _EmptyContents(),
          connectorBuilder: (_, index, __) {
            if (index == 0) {
              return SolidLineConnector(color: Color(0xff6ad192));
            } else {
              return SolidLineConnector();
            }
          },
          indicatorBuilder: (_, index) {
            switch (data[index]) {
              case _TimelineStatus.done:
                return DotIndicator(
                  color: Color(0xff6ad192),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.0,
                  ),
                );
              case _TimelineStatus.sync:
                return DotIndicator(
                  color: Color(0xff193fcc),
                  child: Icon(
                    Icons.sync,
                    size: 10.0,
                    color: Colors.white,
                  ),
                );
              case _TimelineStatus.inProgress:
                return OutlinedDotIndicator(
                  color: Color(0xffa7842a),
                  borderWidth: 2.0,
                  backgroundColor: Color(0xffebcb62),
                );
              case _TimelineStatus.todo:
              default:
                return OutlinedDotIndicator(
                  color: Color(0xffbabdc0),
                  backgroundColor: Color(0xffe6e7e9),
                );
            }
          },
          itemExtentBuilder: (_, __) => kTileHeight,
          itemCount: data.length,
        ),
      ),
    );
  }
}

class _Timeline2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<_TimelineStatus> data = [
      _TimelineStatus.done,
      _TimelineStatus.inProgress,
      _TimelineStatus.inProgress,
      _TimelineStatus.todo
    ];

    return Flexible(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          color: Color(0xffc2c5c9),
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
          ),
        ),
        padding: EdgeInsets.only(top: 20.0),
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (context, index) {
            return DotIndicator(
              color: data[index].isInProgress ? Color(0xff193fcc) : null,
            );
          },
          connectorBuilder: (_, index, connectorType) {
            var color;
            if (index + 1 < data.length - 1) {
              color = data[index].isInProgress && data[index + 1].isInProgress
                  ? Color(0xff193fcc)
                  : null;
            }
            return SolidLineConnector(
              indent: connectorType == ConnectorType.start ? 0 : 2.0,
              endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
              color: color,
            );
          },
          contentsBuilder: (_, __) => _EmptyContents(),
          itemExtentBuilder: (_, __) {
            return kTileHeight;
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}

class _Timeline3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<_TimelineStatus> data = [
      _TimelineStatus.done,
      _TimelineStatus.inProgress,
      _TimelineStatus.inProgress,
      _TimelineStatus.todo
    ];

    return Flexible(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          nodeItemOverlap: true,
          connectorTheme: ConnectorThemeData(
            color: Color(0xffe6e7e9),
            thickness: 15.0,
          ),
        ),
        padding: EdgeInsets.only(top: 20.0),
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (context, index) {
            final status = data[index];
            return OutlinedDotIndicator(
              color:
                  status.isInProgress ? Color(0xff6ad192) : Color(0xffe6e7e9),
              backgroundColor:
                  status.isInProgress ? Color(0xffd4f5d6) : Color(0xffc2c5c9),
              borderWidth: status.isInProgress ? 3.0 : 2.5,
            );
          },
          connectorBuilder: (context, index, connectorType) {
            var color;
            if (index + 1 < data.length - 1 &&
                data[index].isInProgress &&
                data[index + 1].isInProgress) {
              color = data[index].isInProgress ? Color(0xff6ad192) : null;
            }
            return SolidLineConnector(
              color: color,
            );
          },
          contentsBuilder: (context, index) {
            var height;
            if (index + 1 < data.length - 1 &&
                data[index].isInProgress &&
                data[index + 1].isInProgress) {
              height = kTileHeight - 10;
            } else {
              height = kTileHeight + 5;
            }
            return SizedBox(
              height: height,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _EmptyContents(),
              ),
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      height: 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Color(0xffe6e7e9),
      ),
    );
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
