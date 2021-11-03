import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

class LineWrapper extends StatelessWidget {
  final Widget child;
  final bool isBeforeHeader;

  LineWrapper({Key? key, required this.child, required this.isBeforeHeader}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: !isBeforeHeader ? InheritedJsonFormTheme
            .of(context)
            .theme
            .linePaDecoration : InheritedJsonFormTheme
            .of(context)
            .theme
            .linePaDecorationAboveHeader,
        padding: InheritedJsonFormTheme
            .of(context)
            .theme
            .linePadding,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        child: child);
  }
}
