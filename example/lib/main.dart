import 'dart:async';
import 'dart:math';

import 'package:example/drop_down_parser2.dart';
import 'package:example/widget_parser_factory.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {}



  final Map<String, dynamic> json = {
    "widgets": [
      {"type": "header", "name": "Header", "id": "29"},
      {
        "id": "1",
        "name": "DVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": "Off",
        "time": 1630164109066,
      },
      {"type": "header", "name": "Header2", "id": "39"},
      {
        "id": "56",
        "name": "ADVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": "Off",
        "time": 1630164109056,
      },
      {
        "id": "2",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "26",
        "name": "Long name of the line but a short",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "3",
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "Val",
        "time": 1640260609562,
        "description": "(edit description..) this a long description! realy",
      },
      {
        "id": "13",
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "Val",
        "read_only": true,
        "time": 1640260609562,
        "description": "(edit description..)",
      },
      {
        "id": "14",
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut libero eu justo ullamcorper tristique. Vivamus sed ex quis nisl sodales sollicitudin. Vestibulum maximus, urna non venenatis condimentum, nibh nunc egestas felis, vel posuere est felis sit amet metus. Donec consequat vel felis luctus dignissim. Praesent sagittis, nulla id volutpat iaculis, nunc neque pretium augue, non viverra enim lorem eu tortor. Ut finibus dignissim tellus et luctus. Donec sit amet porttitor ante.",
        "read_only": false,
        'long': true,
        "time": 1640260609562,
        "description": "(edit description..)",
      },
      {"type": "header", "name": "Header", "id": "99"},
      {
        "id": "4",
        "name": "Drop down",
        "type": "drop_down",
        "time": 1640264109066,
        "values": ["Low-Intermediate", "Medium", "High"],
        "chosen_value": "Low-Intermediate"
      },
      {
        "id": "5",
        "name": "Dynamic Drop down",
        "type": "drop_down2",
        "values": ["one", "two", "three"],
        "chosen_value": "one",
        "time": 1530164109066,
      }
    ]
  };

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<Map<String, dynamic>>? onValueChangeStream;
  final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();

  Map<String, WidgetParser> dynamics = {};

  @override
  void initState() {
    super.initState();
    onValueChangeStream = _onUserController.stream.asBroadcastStream();
  }

  String buildDate(DateTime dateTime) {
    final now = DateTime.now();
    int diff = now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    if (diff < dayInMilliseconds) {
      return build24String(diff);
    } else if (diff >= dayInMilliseconds && diff < monthInMilliseconds) {
      return buildDaysString(diff);
    } else if (diff >= monthInMilliseconds && diff < yearInMilliseconds) {
      return buildMonthString(dateTime);
    }
    return dateTime.year.toString();
  }

  String buildDaysString(int diff) {
    int days = diff ~/ dayInMilliseconds;
    return "${days}d";
  }

  String buildMonthString(DateTime dateTime) {
    return DateFormat.MMMd().format(dateTime);
  }

  int yearInMilliseconds = 31556952000;
  int monthInMilliseconds = 2629800000;
  int weekInMilliseconds = 604800000;
  int dayInMilliseconds = 86400000;
  int hourInMilliseconds = 3600000;
  int minuteInMilliseconds = 60000;

  String build24String(int diff) {
    int hours = diff ~/ hourInMilliseconds;
    int minutes = (diff - (hours * hourInMilliseconds)) ~/ minuteInMilliseconds;
    return "${hours}h ${minutes}m";
  }

  Widget dateBuilder(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return Text(buildDate(dateTime));
  }

  List<String> list = ["Medium", "High"];
  final toggleList = ["On", "Off"];

  int counter = 0;
  int toggle = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button'),
      ),
      body: JsonFormWithTheme(
          jsonWidgets: widget.json,
          dateBuilder: dateBuilder,
          dynamicFactory: MyWidgetParserFactory(),
          streamUpdates: onValueChangeStream,
          onValueChanged: (String d, dynamic s) {
            print("Update id $d to value $s");
          },
          theme: const DefaultTheme()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          if (counter % 4 == 1) {
            toggle++;
            _onUserController.add({}..["1"] = toggleList[toggle % 2]); // toggle
          }
          if (counter % 4 == 2) {
            _onUserController.add({}..["2"] =
                "updated" + Random().nextInt(10).toString()); // toggle
          }
          if (counter % 4 == 3) {
            _onUserController.add(
                {}..["3"] = "Val" + Random().nextInt(10).toString()); // toggle
          }
          if (counter % 4 == 0) {
            _onUserController.add({}..["4"] = list[toggle % 2]); // toggle
          }
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }
}
