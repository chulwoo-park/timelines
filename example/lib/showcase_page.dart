import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'showcase/package_delivery_tracking.dart';
import 'showcase/process_timeline.dart';
import 'showcase/timeline_status.dart';
import 'widget.dart';

class ShowcasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('Showcase'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cards = [
            _ShowcaseCard(
              image: 'assets/images/timeline_status.png',
              title: 'Timeline Status',
              designer: 'Tridip Thrizu',
              url:
                  'https://dribbble.com/shots/5659998-Daily-UI-Component-4-Timeline-Status',
              navigationBuilder: () => TimelineStatusPage(),
            ),
            _ShowcaseCard(
              image: 'assets/images/package_delivery_tracking.png',
              title: 'Package Delivery Tracking',
              designer: 'Series Eight',
              url:
                  'https://dribbble.com/shots/1899993-Package-Delivery-Tracking/attachments/1899993-Package-Delivery-Tracking?mode=media',
              navigationBuilder: () => PackageDeliveryTrackingPage(),
            ),
            _ShowcaseCard(
              image: 'assets/images/process_timeline.png',
              title: 'Process Timeline',
              designer: 'Eddie Lobanovskiy',
              url: 'https://dribbble.com/shots/5260798-Process',
              navigationBuilder: () => ProcessTimelinePage(),
            ),
          ];

          if (constraints.maxWidth >= 760) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Wrap(
                  children: cards
                      .map(
                        (card) => SizedBox(width: 320.0, child: card),
                      )
                      .toList(),
                ),
              ),
            );
          } else {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              children: cards,
            );
          }
        },
      ),
    );
  }
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({
    Key? key,
    required this.navigationBuilder,
    required this.image,
    required this.title,
    required this.designer,
    required this.url,
  }) : super(key: key);

  final String image;
  final String title;
  final String designer;
  final String url;

  final NavigateWidgetBuilder navigationBuilder;

  Widget _forceLightTheme(BuildContext context, Widget child) {
    return Theme(
      data: ThemeData.light(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationCard(
      navigationBuilder: () => _forceLightTheme(context, navigationBuilder()),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(title),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.dribbble,
                              semanticLabel: 'Original',
                              size: 10.0,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 6.0),
                            Flexible(
                              child: Text(
                                'Designed by $designer',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (await canLaunch(url)) await launch(url);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
