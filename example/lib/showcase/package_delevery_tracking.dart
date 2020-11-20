import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../widget.dart';

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('Package Delivery Tracking'),
      body: TimelineTheme(
        data: TimelineThemeData(
          color: Color(0xff989898),
          indicatorTheme: IndicatorThemeData(
            position: 0,
            size: 20.0,
          ),
          connectorTheme: ConnectorThemeData(
            thickness: 2.5,
          ),
        ),
        child: Center(
          child: Container(
            width: 360.0,
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          'Delivery #4565',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '25/12/2020',
                          style: TextStyle(
                            color: Color(0xffb6b2b2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1.0),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Color(0xff9b9b9b),
                      fontSize: 12.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            node: TimelineNode(
                              indicator: OutlinedDotIndicator(
                                borderWidth: 2.5,
                              ),
                              endConnector: SolidLineConnector(),
                            ),
                            contents: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _InnerTimeline(
                                title: 'Package Process',
                                messages: [
                                  '8:30am Package received by driver',
                                  '11:30am Reached halfway mark',
                                ],
                              ),
                            ),
                          ),
                          TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            node: TimelineNode(
                              indicator: OutlinedDotIndicator(
                                borderWidth: 2.5,
                              ),
                              endConnector: SolidLineConnector(color: Color(0xff66c97f)),
                            ),
                            contents: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _InnerTimeline(
                                title: 'In Transit',
                                messages: [
                                  '13:00pm Driver arrived at destination',
                                  '11:35am Package delivered by m.vassiliades',
                                ],
                              ),
                            ),
                          ),
                          TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            node: TimelineNode(
                              indicator: DotIndicator(
                                color: Color(0xff66c97f),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              ),
                              endConnector: SolidLineConnector(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => MaterialButton(
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('On-time!'),
                                ),
                              );
                            },
                            elevation: 0,
                            shape: StadiumBorder(),
                            color: Color(0xff66c97f),
                            textColor: Colors.white,
                            child: Text('On-time'),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Driver\nPhilipe',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 12.0),
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    @required this.title,
    @required this.messages,
  });

  final String title;
  final List<String> messages;

  Widget _buildMessage(String message) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineTheme.of(context).copyWith(
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(thickness: 1.0),
        indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
              size: 10.0,
              position: 0.5,
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) => Text(
              title,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 18.0,
                  ),
            ),
          ),
          TimelineTile(
            nodeAlign: TimelineNodeAlign.start,
            node: TimelineNode(
              overlap: true,
              indicator: Indicator.transparent(),
              endConnector: SolidLineConnector(),
            ),
          ),
          ...messages.map((message) {
            return TimelineTile(
              nodeAlign: TimelineNodeAlign.start,
              node: TimelineNode(
                indicator: OutlinedDotIndicator(
                  borderWidth: 1.0,
                ),
                startConnector: SolidLineConnector(),
                endConnector: SolidLineConnector(),
              ),
              contents: _buildMessage(message),
              mainAxisExtent: 30.0,
            );
          }).toList(),
          TimelineTile(
            nodeAlign: TimelineNodeAlign.start,
            node: TimelineNode(
              overlap: true,
              indicator: Indicator.transparent(),
              startConnector: SolidLineConnector(),
            ),
          ),
        ],
      ),
    );
  }
}
