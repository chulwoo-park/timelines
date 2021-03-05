import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'widget.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final _themeColors = {
    'RED': Colors.red,
    'GREEN': Colors.green,
    'BLUE': Colors.blue,
    'AMBER': Colors.amber,
    'TEAL': Colors.teal,
    'ORANGE': Colors.orange,
  };

  late TimelineThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = TimelineThemeData();
  }

  void _updateTheme(TimelineThemeData theme) {
    if (_theme != theme) {
      setState(() {
        _theme = theme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('Theme'),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20.0, 160.0, 20.0, 40.0),
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text('contents: '),
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 10.0),
                      Text('opposite contents: '),
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'TimelineTheme',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _ThemeDropdown(
                        title: 'Direction',
                        items: {
                          'Vertical': Axis.vertical,
                          'Horizontal': Axis.horizontal,
                        },
                        value: _theme.direction,
                        onChanged: (Axis? axis) {
                          if (_theme.direction != axis) {
                            setState(() {
                              _updateTheme(_theme.copyWith(direction: axis));
                            });
                          }
                        },
                      ),
                      _ThemeDropdown(
                        title: 'Color',
                        items: _themeColors,
                        value: _theme.color,
                        onChanged: (Color? color) {
                          _updateTheme(_theme.copyWith(color: color));
                        },
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text('Node item overlap'),
                          SizedBox(width: 12.0),
                          Checkbox(
                            value: _theme.nodeItemOverlap,
                            onChanged: (overlap) {
                              _updateTheme(
                                  _theme.copyWith(nodeItemOverlap: overlap));
                            },
                          ),
                        ],
                      ),
                      _ThemeSlider(
                        title: 'Node Position',
                        value: _theme.nodePosition,
                        onChanged: (nodePosition) {
                          _updateTheme(
                              _theme.copyWith(nodePosition: nodePosition));
                        },
                      ),
                      _ThemeSlider(
                        title: 'Indicator Position',
                        value: _theme.indicatorPosition,
                        onChanged: (indicatorPosition) {
                          _updateTheme(_theme.copyWith(
                              indicatorPosition: indicatorPosition));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'IndicatorTheme',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _ThemeDropdown<Color?>(
                        title: 'Color',
                        items: _themeColors,
                        value: _theme.indicatorTheme.color,
                        onChanged: (color) {
                          _updateTheme(
                            _theme.copyWith(
                              indicatorTheme:
                                  _theme.indicatorTheme.copyWith(color: color),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      _ThemeSlider(
                        title: 'Position',
                        value: _theme.indicatorTheme.position ?? 0,
                        onChanged: (position) {
                          _updateTheme(
                            _theme.copyWith(
                              indicatorTheme: _theme.indicatorTheme
                                  .copyWith(position: position),
                            ),
                          );
                        },
                      ),
                      _ThemeSlider(
                        title: 'Size',
                        value: _theme.indicatorTheme.size ?? 0,
                        max: 100.0,
                        onChanged: (size) {
                          _updateTheme(
                            _theme.copyWith(
                              indicatorTheme:
                                  _theme.indicatorTheme.copyWith(size: size),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'ConnectorTheme',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _ThemeDropdown<Color?>(
                        title: 'Color',
                        items: _themeColors,
                        value: _theme.connectorTheme.color,
                        onChanged: (color) {
                          _updateTheme(
                            _theme.copyWith(
                              connectorTheme:
                                  _theme.connectorTheme.copyWith(color: color),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      _ThemeSlider(
                        title: 'Space',
                        value: _theme.connectorTheme.space ?? 0,
                        max: 100,
                        onChanged: (space) {
                          _updateTheme(
                            _theme.copyWith(
                              connectorTheme:
                                  _theme.connectorTheme.copyWith(space: space),
                            ),
                          );
                        },
                      ),
                      _ThemeSlider(
                        title: 'Indent',
                        value: _theme.connectorTheme.indent ?? 0,
                        max: 22,
                        onChanged: (indent) {
                          _updateTheme(
                            _theme.copyWith(
                              connectorTheme: _theme.connectorTheme
                                  .copyWith(indent: indent),
                            ),
                          );
                        },
                      ),
                      _ThemeSlider(
                        title: 'Thickness',
                        value: _theme.connectorTheme.thickness ?? 0,
                        max: 100,
                        onChanged: (thickness) {
                          _updateTheme(
                            _theme.copyWith(
                              connectorTheme: _theme.connectorTheme
                                  .copyWith(thickness: thickness),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Card(
            elevation: 3,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: TimelineTheme(
                data: _theme,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimelineTile(
                      mainAxisExtent: 100,
                      crossAxisExtent: 100,
                      oppositeContents: Container(color: Colors.amber),
                      node: TimelineNode(
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                        indicator: OutlinedDotIndicator(),
                      ),
                      contents: Container(color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeDropdown<T> extends StatelessWidget {
  const _ThemeDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final Map<String, T> items;
  final T value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        SizedBox(width: 10.0),
        DropdownButton(
          items: items.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ThemeSlider extends StatelessWidget {
  const _ThemeSlider({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.max = 1.0,
  }) : super(key: key);

  final String title;
  final double? value;
  final ValueChanged<double> onChanged;
  final double max;

  @override
  Widget build(BuildContext context) {
    var label;
    if (value == null) {
      label = '';
    } else if (value! > 1) {
      label = value!.toInt().toString();
    } else {
      label = value.toString();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(width: 10.0),
        Slider(
          label: label,
          max: max,
          divisions: 100,
          value: value ?? 0,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
