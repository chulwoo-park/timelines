import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'widget.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('Timeline'),
      body: Container(
        color: Colors.blue,
        child: Timeline(
          children: [
            Text('hi'),
            Text('hi'),
            Text('hi'),
            Text('hi'),
          ],
        ),
      ),
    );
  }
}
