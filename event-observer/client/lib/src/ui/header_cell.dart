import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final String text;
  final bool centered;

  const HeaderCell(this.text,
      {super.key,
      this.backgroundColor = Colors.black26,
      this.color = Colors.blueAccent,
      this.centered = false});

  @override
  Widget build(BuildContext context) {
    var valueWidget = Text(text,
        style:
            TextStyle(fontSize: 50, color: color, fontWeight: FontWeight.bold));
    return TableCell(
        child: Container(
      color: backgroundColor,
      child: centered
          ? Center(
              child: valueWidget,
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: valueWidget,
            ),
    ));
  }
}
