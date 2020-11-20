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
    return TimelineTheme(
      data: TimelineThemeData(
        nodePosition: 0,
        connectorTheme: ConnectorThemeData(
          thickness: 3.0,
        ),
        indicatorTheme: IndicatorThemeData(
          size: 15.0,
        ),
      ),
      child: Flexible(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          children: [
            TimelineTile(
              node: TimelineNode.simple(
                drawStartConnector: false,
                color: Color(0xff6ad192),
                indicatorChild: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10.0,
                ),
              ),
              mainAxisExtent: kTileHeight,
              contents: Center(child: _EmptyContents()),
            ),
            // It will be even simpler.
            TimelineTile(
              node: TimelineNode(
                indicator: DotIndicator(
                  color: Color(0xff193fcc),
                  child: Icon(
                    Icons.sync,
                    size: 10.0,
                    color: Colors.white,
                  ),
                ),
                startConnector: SolidLineConnector(
                  color: Color(0xff6ad192),
                ),
                endConnector: SolidLineConnector(
                  color: Color(0xffd3d3d3),
                ),
              ),
              mainAxisExtent: kTileHeight,
              contents: Center(
                child: _EmptyContents(),
              ),
            ),
            Builder(
              builder: (context) => ConnectorTheme(
                data: ConnectorTheme.of(context).copyWith(
                  color: Color(0xffd3d3d3),
                ),
                child: TimelineTile(
                  node: TimelineNode(
                    indicator: OutlinedDotIndicator(
                      color: Color(0xffa7842a),
                      borderWidth: 2.0,
                      backgroundColor: Color(0xffebcb62),
                    ),
                    startConnector: SolidLineConnector(),
                    endConnector: SolidLineConnector(),
                  ),
                  mainAxisExtent: kTileHeight,
                  contents: Center(
                    child: _EmptyContents(),
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) => ConnectorTheme(
                data: ConnectorTheme.of(context).copyWith(
                  color: Color(0xffd3d3d3),
                ),
                child: TimelineTile(
                  node: TimelineNode(
                    indicator: OutlinedDotIndicator(
                      color: Color(0xffbabdc0),
                      backgroundColor: Color(0xffe6e7e9),
                    ),
                    startConnector: SolidLineConnector(),
                  ),
                  mainAxisExtent: kTileHeight,
                  contents: Center(
                    child: _EmptyContents(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineThemeData(
        nodePosition: 0,
        connectorTheme: ConnectorThemeData(
          thickness: 3.0,
        ),
      ),
      child: Flexible(
        child: ListView(
          padding: EdgeInsets.only(top: 20.0),
          children: [
            TimelineTile(
              node: TimelineNode.simple(
                color: Color(0xffc2c5c9),
                drawStartConnector: false,
              ),
              mainAxisExtent: kTileHeight,
              contents: Center(child: _EmptyContents()),
            ),
            // It will be even simpler.
            TimelineTile(
              node: TimelineNode(
                indicator: DotIndicator(
                  color: Color(0xff193fcc),
                ),
                startConnector: SolidLineConnector(
                  color: Color(0xffc2c5c9),
                  endIndent: 2.0,
                ),
                endConnector: SolidLineConnector(
                  indent: 2.0,
                  color: Color(0xff193fcc),
                ),
              ),
              mainAxisExtent: kTileHeight,
              contents: Center(
                child: _EmptyContents(),
              ),
            ),
            TimelineTile(
              node: TimelineNode(
                indicator: DotIndicator(
                  color: Color(0xff193fcc),
                ),
                startConnector: SolidLineConnector(
                  color: Color(0xff193fcc),
                  endIndent: 2.0,
                ),
                endConnector: SolidLineConnector(
                  indent: 2.0,
                  color: Color(0xffc2c5c9),
                ),
              ),
              mainAxisExtent: kTileHeight,
              contents: Center(
                child: _EmptyContents(),
              ),
            ),
            Builder(
              builder: (context) => TimelineTheme(
                data: TimelineTheme.of(context).copyWith(
                  color: Color(0xffc2c5c9),
                ),
                child: TimelineTile(
                  node: TimelineNode(
                    indicator: DotIndicator(),
                    startConnector: SolidLineConnector(
                      endIndent: 2.0,
                    ),
                  ),
                  mainAxisExtent: kTileHeight,
                  contents: Center(
                    child: _EmptyContents(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineThemeData(
        nodePosition: 0,
        nodeItemOverlap: true,
        connectorTheme: ConnectorThemeData(
          color: Color(0xffe6e7e9),
          thickness: 15.0,
        ),
      ),
      child: Flexible(
        child: ListView(
          padding: EdgeInsets.only(top: 40.0),
          children: [
            TimelineTile(
              node: TimelineNode(
                indicator: OutlinedDotIndicator(
                  color: Color(0xffe6e7e9),
                  backgroundColor: Color(0xffc2c5c9),
                  borderWidth: 2.5,
                ),
                endConnector: SolidLineConnector(
                  indent: 7.5,
                ),
                indicatorPosition: 0,
              ),
              mainAxisExtent: kTileHeight - 10,
              contents: Align(
                child: _EmptyContents(),
                alignment: Alignment.topCenter,
              ),
            ),
            // It will be even simpler.
            TimelineTile(
              node: TimelineNode(
                indicator: OutlinedDotIndicator(
                  backgroundColor: Color(0xffd4f5d6),
                  color: Color(0xff6ad192),
                  borderWidth: 3.0,
                ),
                startConnector: SolidLineConnector(),
                endConnector: SolidLineConnector(
                  color: Color(0xff6ad192),
                ),
              ),
              mainAxisExtent: kTileHeight - 10,
              contents: Center(
                child: _EmptyContents(),
              ),
            ),
            TimelineTile(
              node: TimelineNode(
                indicator: OutlinedDotIndicator(
                  backgroundColor: Color(0xffd4f5d6),
                  color: Color(0xff6ad192),
                  borderWidth: 3.5,
                ),
                startConnector: SolidLineConnector(
                  color: Color(0xff6ad192),
                ),
                endConnector: SolidLineConnector(),
              ),
              mainAxisExtent: kTileHeight - 10,
              contents: Center(
                child: _EmptyContents(),
              ),
            ),
            Builder(
              builder: (context) => TimelineTheme(
                data: TimelineTheme.of(context).copyWith(
                  color: Color(0xffc2c5c9),
                ),
                child: TimelineTile(
                  node: TimelineNode(
                    indicatorPosition: 1,
                    indicator: OutlinedDotIndicator(
                      color: Color(0xffe6e7e9),
                      backgroundColor: Color(0xffc2c5c9),
                      borderWidth: 2.5,
                    ),
                    startConnector: SolidLineConnector(
                      endIndent: 7.5,
                    ),
                  ),
                  mainAxisExtent: kTileHeight - 10,
                  contents: Center(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: _EmptyContents(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
