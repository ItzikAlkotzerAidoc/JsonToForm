import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/edit_text_value.dart';

import '../json_to_form_with_theme.dart';

class EditTextParser implements WidgetParser {
  EditTextParser(this.name, this.description, this.id, this.chosenValue,
      this.onValueChanged, this.isBeforeHeader, this.index, this.dateBuilder) {
    onValueChangedLocal = (String id, dynamic value) {
      chosenValue = value;
      if (onValueChanged != null) {
        onValueChanged!(id, value);
      }
    };
  }

  final OnValueChanged? onValueChanged;
  final String? description;
  final String name;
  bool readOnly = false;
  bool long = false;
  @override
  final String id;
  @override
  dynamic chosenValue;
  final bool isBeforeHeader;
  OnValueChanged? onValueChangedLocal;
  final Widget Function(int date)? dateBuilder;
  @override
  int? time;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'chosen_value': chosenValue,
        'read_only': readOnly,
        'long': long,
        'time': time,
        'long': long
      };

  @override
  Widget getWidget() {
    return EditTextValue(
        name: name,
        id: id,
        description: description,
        chosenValue: chosenValue,
        key: ValueKey(id),
        isBeforeHeader: isBeforeHeader,
        onValueChanged: onValueChanged,
        time: time,
        long: long,
        isReadOnly: readOnly,
        dateBuilder: dateBuilder);
  }

  @override
  int index;

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  EditTextParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
      this.isBeforeHeader, this.index,
      [this.dateBuilder])
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        time = json['time'],
        long = json["long"] ?? false,
        readOnly = json['read_only'] ?? false,
        chosenValue = json['chosen_value'] ?? "";

  @override
  setChosenValue(value) {
    chosenValue = value ?? "";
  }
}
