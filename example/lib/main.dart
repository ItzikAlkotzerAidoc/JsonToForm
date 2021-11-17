import 'dart:async';
import 'dart:math';

import 'package:example/drop_down_parser2.dart';
import 'package:example/widget_parser_factory.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';

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
      {
        "id": "1",
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": 1
      },
      {
        "id": "2",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
      },
      {
        "id": "3",
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "Val",
        "description": "(edit description..)",
      },
      {"type": "header", "name": "Header", "id": "99"},
      {
        "id": "4",
        "name": "Drop down",
        "type": "drop_down",
        "values": ["Low-Intermediate", "Medium", "High"],
        "chosen_value": "Low-Intermediate"
      },
      {
        "id": "5",
        "name": "Dynamic Drop down",
        "type": "drop_down2",
        "values": ["one", "two", "three"],
        "chosen_value": "one"
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
  //  dynamics["drop_down2"] = DropDownParser2(name, description, id, chosenValue, values, onValueChanged, isBeforeHeader, index)
    super.initState();
    onValueChangeStream = _onUserController.stream.asBroadcastStream();
  }

  List<String> list = ["Medium", "High"];

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
            _onUserController.add({}..["1"] = toggle % 2); // toggle
          }
          if (counter % 4 == 2) {
            _onUserController.add({}..["2"] =
                "updated" + Random().nextInt(10).toString()); // toggle
          }
          if (counter % 4 == 3) {
            _onUserController.add({}..["3"] =
                "Val" + Random().nextInt(10).toString()); // toggle
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
